import CryptoKit
import Foundation
import Hub
import ZIPFoundation

/// Downloads and caches model weights from HuggingFace, content-addressed by
/// HuggingFace's LFS oid (SHA-256). Generalized from `uhm`'s `ModelDownloader`
/// so every `<name>-swift` SDK in `desert-ant-labs` can share one implementation.
///
/// **Pattern.** There is no manifest baked into the SDK. On each first fetch
/// `ModelStore` calls HuggingFace's tree API for `<owner>/<repo>` at the
/// configured revision, reads each file's `lfs.oid` (which is the SHA-256 of
/// its content under HF's content-addressable storage), and uses that as both
/// the integrity check and the cache key. New weights pushed to HF `main` are
/// picked up by every install on next download without a Swift package
/// release; cached copies remain valid because the cache is keyed by oid.
///
/// **Fetch modes.**
/// - `file(_:)` — a single file (e.g. `vocab.json`). Returned as a file URL in
///   Application Support, content-addressed by HF `lfs.oid`.
/// - `archive(_:unpackedAs:approxBytes:)` — a zip on HF that contains a single
///   bundle. The bundle is extracted into the cache atomically and the unpacked
///   URL is returned. (Legacy; prefer `snapshot` for unzipped bundles.)
/// - `snapshot(matching:)` — downloads an *unzipped* directory bundle (e.g. a
///   `.mlmodelc/`) via the Hugging Face Hub API (swift-transformers). The Hub
///   client does per-file etag/commit diffing and shared-cache reuse, so
///   re-fetches only pull the files that changed. Returns the snapshot root.
///
/// **Offline fallback.** If HF's tree API is unreachable but a previous
/// download exists for the same logical artifact (any revision), the newest
/// cached copy is returned — stale weights beat no weights.
///
/// **Auth.** If `HF_TOKEN` or `HUGGINGFACE_TOKEN` is set in the environment,
/// the request carries `Authorization: Bearer …`. Without a token, the repo
/// must be public.
///
/// **Per-repo overrides.** A consumer can pin the revision via an env var,
/// or point the store at a local mirror for bring-up. See `Repo.envPrefix`.
public actor ModelStore {

    // MARK: - Repo descriptor

    public struct Repo: Sendable, Hashable {
        public let owner: String
        public let name: String
        public let revision: String

        /// Construct a HuggingFace repo descriptor.
        ///
        /// - Parameters:
        ///   - owner: HF org or user. Defaults to `desert-ant-labs`.
        ///   - name: Repo name (e.g. `eye`).
        ///   - revision: `main`, a tag (`v2.0.0`), or a commit sha. The env
        ///     var `DESERT_ANT_<NAME>_REVISION` (with `<NAME>` upper-cased)
        ///     overrides it at runtime — useful for pinning or rollback.
        public init(owner: String = "desert-ant-labs", name: String, revision: String = "main") {
            self.owner = owner
            self.name = name
            self.revision = Self.resolvedRevision(name: name, fallback: revision)
        }

        /// `DESERT_ANT_<NAME>_REVISION` overrides the constructor revision.
        private static func resolvedRevision(name: String, fallback: String) -> String {
            let key = "DESERT_ANT_\(envSlug(name))_REVISION"
            if let v = ProcessInfo.processInfo.environment[key], !v.isEmpty {
                return v
            }
            return fallback
        }

        /// `DESERT_ANT_<NAME>_BASE_URL` lets a consumer redirect downloads
        /// at runtime (local mirror during bring-up, staging during a release).
        /// Bypasses revision-based URL construction entirely when set.
        var baseURLOverride: URL? {
            let key = "DESERT_ANT_\(Self.envSlug(name))_BASE_URL"
            if let s = ProcessInfo.processInfo.environment[key],
               let u = URL(string: s) {
                return u
            }
            return nil
        }

        var resolveBaseURL: URL {
            baseURLOverride
                ?? URL(string: "https://huggingface.co/\(owner)/\(name)/resolve/\(revision)")!
        }

        var treeURL: URL {
            URL(string: "https://huggingface.co/api/models/\(owner)/\(name)/tree/\(revision)")!
        }

        private static func envSlug(_ s: String) -> String {
            s.uppercased()
                .map { $0.isLetter || $0.isNumber ? String($0) : "_" }
                .joined()
        }
    }

    // MARK: - Errors

    public enum Failure: Swift.Error, LocalizedError {
        case downloadFailed(URL, underlying: Swift.Error)
        case noNetworkAndNoCache(file: String)
        case insufficientDiskSpace(required: Int64, available: Int64)
        case checksumMismatch(file: String, expected: String, actual: String)
        case manifestUnavailable(underlying: Swift.Error)
        case unexpectedArchiveContents(expected: String)

        public var errorDescription: String? {
            switch self {
            case .downloadFailed(let url, let e):
                return "download failed: \(url) — \(e.localizedDescription)"
            case .noNetworkAndNoCache(let f):
                return "\(f) not cached and no network available"
            case .insufficientDiskSpace(let req, let avail):
                return "not enough disk space: need \(Self.bytes(req)), available \(Self.bytes(avail))"
            case .checksumMismatch(let f, let expected, let actual):
                return "checksum mismatch for \(f): expected \(expected.prefix(12))… got \(actual.prefix(12))…"
            case .manifestUnavailable(let e):
                return "could not fetch HF tree metadata: \(e.localizedDescription)"
            case .unexpectedArchiveContents(let expected):
                return "archive did not contain \(expected)"
            }
        }

        private static func bytes(_ n: Int64) -> String {
            ByteCountFormatter.string(fromByteCount: n, countStyle: .file)
        }
    }

    public typealias Progress = @Sendable (Double) -> Void

    // MARK: - State

    public let repo: Repo
    private var cachedTree: [String: TreeEntry]?

    public init(_ repo: Repo) {
        self.repo = repo
    }

    private var hfToken: String? {
        ProcessInfo.processInfo.environment["HF_TOKEN"]
            ?? ProcessInfo.processInfo.environment["HUGGINGFACE_TOKEN"]
    }

    // MARK: - Public API

    /// Returns a local file URL for a single file in the repo, downloading
    /// it if needed. Cache key is `<filename>@<oid12>.<ext>` so a new push to
    /// HF lands a new file alongside the old one.
    public func file(_ filename: String, progress: Progress? = nil) async throws -> URL {
        let cache = try cacheDir()
        let tree = try? await fetchTree()
        if let entry = tree?[filename], let oid = entry.lfs?.oid {
            let local = cache.appendingPathComponent(versionedName(filename, oidPrefix: String(oid.prefix(12))))
            if FileManager.default.fileExists(atPath: local.path) {
                progress?(1.0)
                return local
            }
            let remote = repo.resolveBaseURL.appendingPathComponent(filename)
            return try await downloadVerified(
                from: remote, expectedSha256: oid,
                destination: local, progress: progress)
        }
        if let stale = newestCached(matching: filename, in: cache) {
            progress?(1.0)
            return stale
        }
        throw Failure.noNetworkAndNoCache(file: filename)
    }

    /// Downloads a zip archive from the repo, verifies it against HF's oid,
    /// and extracts the named bundle inside it (e.g. `model.mlpackage`).
    /// Returns the URL of the extracted bundle.
    ///
    /// - Parameters:
    ///   - filename: archive name in the HF repo (e.g. `model.mlpackage.zip`).
    ///   - unpackedName: the directory or file inside the archive to surface.
    ///   - approxBytes: best-guess unpacked size in bytes — used for the
    ///     pre-download disk-space check.
    public func archive(_ filename: String,
                        unpackedAs unpackedName: String,
                        approxBytes: Int64,
                        progress: Progress? = nil) async throws -> URL {
        let cache = try cacheDir()
        let tree = try? await fetchTree()
        if let entry = tree?[filename], let oid = entry.lfs?.oid {
            let local = cache.appendingPathComponent(versionedName(unpackedName, oidPrefix: String(oid.prefix(12))))
            if FileManager.default.fileExists(atPath: local.path) {
                progress?(1.0)
                return local
            }
            try ensureDiskSpace(bytes: approxBytes * 2, in: cache)
            let remote = repo.resolveBaseURL.appendingPathComponent(filename)
            return try await downloadAndUnzip(
                from: remote, expectedSha256: oid,
                unpackedName: unpackedName, destination: local,
                cache: cache, progress: progress)
        }
        if let stale = newestCached(matching: unpackedName, in: cache) {
            progress?(1.0)
            return stale
        }
        throw Failure.noNetworkAndNoCache(file: unpackedName)
    }

    /// Returns the newest cached copy of `filename` (across all revisions) if
    /// any exists. Lets callers gate the download behind their own UI (e.g.
    /// wifi-only, "downloading…" sheet).
    public nonisolated func cachedFile(_ filename: String) -> URL? {
        guard let dir = try? Self.cacheDirNonisolated(repo: repo) else { return nil }
        return Self.newestCachedNonisolated(matching: filename, in: dir)
    }

    public nonisolated func cachedArchive(unpackedAs unpackedName: String) -> URL? {
        guard let dir = try? Self.cacheDirNonisolated(repo: repo) else { return nil }
        return Self.newestCachedNonisolated(matching: unpackedName, in: dir)
    }

    // MARK: - Snapshot (Hugging Face Hub)

    /// Downloads a repo snapshot via the Hugging Face Hub API (swift-transformers)
    /// and returns the local snapshot root. Prefer this over `archive(...)` for
    /// models shipped as an *unzipped* directory (e.g. a `.mlmodelc`): the Hub
    /// client does per-file etag/commit diffing, so re-fetches only download the
    /// files that actually changed, and unchanged files are reused across
    /// revisions from the shared Hub cache.
    ///
    /// The returned URL is the repo root; the caller appends the bundle it wants
    /// (e.g. `root.appending(path: "uhm.mlmodelc")`). Downloads land under
    /// Application Support so they survive app updates and aren't purged like
    /// Caches on low-storage events.
    ///
    /// - Parameters:
    ///   - globs: file patterns to fetch (e.g. `["uhm.mlmodelc/*"]`). Empty = whole repo.
    ///   - progress: 0…1 aggregate download progress.
    public func snapshot(matching globs: [String] = [],
                         progress: Progress? = nil) async throws -> URL {
        let base = try cacheDir()
        let repoId = "\(repo.owner)/\(repo.name)"
        let hub = HubApi(downloadBase: base, hfToken: hfToken)
        do {
            return try await hub.snapshot(
                from: repoId,
                revision: repo.revision,
                matching: globs
            ) { p in
                progress?(p.fractionCompleted)
            }
        } catch {
            // Offline fallback: a previously materialized snapshot beats nothing.
            let cached = HubApi(downloadBase: base)
                .localRepoLocation(HubApi.Repo(id: repoId))
            if FileManager.default.fileExists(atPath: cached.path) {
                progress?(1.0)
                return cached
            }
            throw Failure.downloadFailed(repo.resolveBaseURL, underlying: error)
        }
    }

    /// Returns the local snapshot root for this repo if it has been materialized,
    /// without hitting the network. Lets callers gate the download behind UI.
    public nonisolated func cachedSnapshot() -> URL? {
        guard let base = try? Self.cacheDirNonisolated(repo: repo) else { return nil }
        let repoId = "\(repo.owner)/\(repo.name)"
        let root = HubApi(downloadBase: base).localRepoLocation(HubApi.Repo(id: repoId))
        return FileManager.default.fileExists(atPath: root.path) ? root : nil
    }

    // MARK: - HF tree

    struct TreeEntry: Decodable {
        let path: String
        let lfs: LFS?
        struct LFS: Decodable {
            let oid: String
            let size: Int64
        }
    }

    private func fetchTree() async throws -> [String: TreeEntry] {
        if let cached = cachedTree { return cached }
        var req = URLRequest(url: repo.treeURL, timeoutInterval: 10.0)
        if let token = hfToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: req)
        } catch {
            throw Failure.manifestUnavailable(underlying: error)
        }
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            throw Failure.manifestUnavailable(underlying: NSError(
                domain: "ModelStore", code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HF tree HTTP \(http.statusCode)"]))
        }
        let entries: [TreeEntry]
        do {
            entries = try JSONDecoder().decode([TreeEntry].self, from: data)
        } catch {
            throw Failure.manifestUnavailable(underlying: error)
        }
        let map = Dictionary(uniqueKeysWithValues: entries.map { ($0.path, $0) })
        cachedTree = map
        return map
    }

    // MARK: - Cache layout

    private func cacheDir() throws -> URL {
        try Self.cacheDirNonisolated(repo: repo)
    }

    static func cacheDirNonisolated(repo: Repo) throws -> URL {
        let appSupport = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil, create: true)
        let dir = appSupport
            .appendingPathComponent("DesertAntLabs", isDirectory: true)
            .appendingPathComponent(repo.name, isDirectory: true)
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir
    }

    private func versionedName(_ name: String, oidPrefix: String) -> String {
        Self.versionedName(name, oidPrefix: oidPrefix)
    }

    static func versionedName(_ name: String, oidPrefix: String) -> String {
        let dot = name.lastIndex(of: ".") ?? name.endIndex
        let stem = name[..<dot]
        let ext = name[dot...]
        return "\(stem)@\(oidPrefix)\(ext)"
    }

    private func newestCached(matching name: String, in dir: URL) -> URL? {
        Self.newestCachedNonisolated(matching: name, in: dir)
    }

    static func newestCachedNonisolated(matching name: String, in dir: URL) -> URL? {
        let dot = name.lastIndex(of: ".") ?? name.endIndex
        let stem = String(name[..<dot])
        let ext = String(name[dot...])
        guard let contents = try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: [.contentModificationDateKey]) else { return nil }
        let candidates = contents.filter {
            let n = $0.lastPathComponent
            return n.hasPrefix("\(stem)@") && n.hasSuffix(ext)
        }
        return candidates.max { a, b in
            let aDate = (try? a.resourceValues(forKeys: [.contentModificationDateKey])
                .contentModificationDate) ?? .distantPast
            let bDate = (try? b.resourceValues(forKeys: [.contentModificationDateKey])
                .contentModificationDate) ?? .distantPast
            return aDate < bDate
        }
    }

    // MARK: - Disk space

    private func ensureDiskSpace(bytes required: Int64, in dir: URL) throws {
        let values = try dir.resourceValues(forKeys: [.volumeAvailableCapacityForImportantUsageKey])
        guard let available = values.volumeAvailableCapacityForImportantUsage else { return }
        if Int64(available) < required {
            throw Failure.insufficientDiskSpace(required: required, available: Int64(available))
        }
    }

    // MARK: - Download

    private func downloadVerified(
        from remote: URL,
        expectedSha256: String,
        destination: URL,
        progress: Progress?
    ) async throws -> URL {
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: remote)
        if let token = hfToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let delegate = progress.map { ProgressDelegate(onProgress: $0) }

        let (tmpURL, response): (URL, URLResponse)
        do {
            (tmpURL, response) = try await session.download(for: req, delegate: delegate)
        } catch {
            throw Failure.downloadFailed(remote, underlying: error)
        }
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            try? FileManager.default.removeItem(at: tmpURL)
            throw Failure.downloadFailed(remote, underlying: NSError(
                domain: "ModelStore", code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]))
        }

        let actual = try Self.sha256(of: tmpURL)
        if actual != expectedSha256 {
            try? FileManager.default.removeItem(at: tmpURL)
            throw Failure.checksumMismatch(
                file: remote.lastPathComponent,
                expected: expectedSha256, actual: actual)
        }

        if FileManager.default.fileExists(atPath: destination.path) {
            try? FileManager.default.removeItem(at: destination)
        }
        do {
            try FileManager.default.moveItem(at: tmpURL, to: destination)
        } catch {
            try? FileManager.default.removeItem(at: tmpURL)
            throw Failure.downloadFailed(remote, underlying: error)
        }
        progress?(1.0)
        return destination
    }

    private func downloadAndUnzip(
        from remote: URL,
        expectedSha256: String,
        unpackedName: String,
        destination: URL,
        cache: URL,
        progress: Progress?
    ) async throws -> URL {
        let session = URLSession(configuration: .default)
        var req = URLRequest(url: remote)
        if let token = hfToken {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        let delegate = progress.map { ProgressDelegate(onProgress: $0) }

        let (tmpURL, response): (URL, URLResponse)
        do {
            (tmpURL, response) = try await session.download(for: req, delegate: delegate)
        } catch {
            throw Failure.downloadFailed(remote, underlying: error)
        }
        if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
            try? FileManager.default.removeItem(at: tmpURL)
            throw Failure.downloadFailed(remote, underlying: NSError(
                domain: "ModelStore", code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]))
        }

        let actual = try Self.sha256(of: tmpURL)
        if actual != expectedSha256 {
            try? FileManager.default.removeItem(at: tmpURL)
            throw Failure.checksumMismatch(
                file: remote.lastPathComponent,
                expected: expectedSha256, actual: actual)
        }

        let staging = cache.appendingPathComponent(".staging-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: staging, withIntermediateDirectories: true)
        defer {
            try? FileManager.default.removeItem(at: staging)
            try? FileManager.default.removeItem(at: tmpURL)
        }

        do {
            try FileManager.default.unzipItem(at: tmpURL, to: staging)
        } catch {
            throw Failure.downloadFailed(remote, underlying: error)
        }

        let extracted = staging.appendingPathComponent(unpackedName)
        guard FileManager.default.fileExists(atPath: extracted.path) else {
            throw Failure.unexpectedArchiveContents(expected: unpackedName)
        }

        if FileManager.default.fileExists(atPath: destination.path) {
            try? FileManager.default.removeItem(at: destination)
        }
        do {
            try FileManager.default.moveItem(at: extracted, to: destination)
        } catch {
            throw Failure.downloadFailed(remote, underlying: error)
        }
        progress?(1.0)
        return destination
    }

    // MARK: - SHA-256

    static func sha256(of url: URL) throws -> String {
        let handle = try FileHandle(forReadingFrom: url)
        defer { try? handle.close() }
        var hasher = SHA256()
        while autoreleasepool(invoking: {
            let chunk = handle.availableData
            if chunk.isEmpty { return false }
            hasher.update(data: chunk)
            return true
        }) {}
        return hasher.finalize().map { String(format: "%02x", $0) }.joined()
    }
}

private final class ProgressDelegate: NSObject, URLSessionDownloadDelegate, @unchecked Sendable {
    let onProgress: @Sendable (Double) -> Void
    init(onProgress: @escaping @Sendable (Double) -> Void) { self.onProgress = onProgress }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        onProgress(Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {}
}
