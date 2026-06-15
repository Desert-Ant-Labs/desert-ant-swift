import XCTest
@testable import DesertAntStore

final class DesertAntStoreTests: XCTestCase {
    func testRepoDefaultsToDesertAntLabs() {
        let repo = ModelStore.Repo(name: "eye")
        XCTAssertEqual(repo.owner, "desert-ant-labs")
        XCTAssertEqual(repo.name, "eye")
        XCTAssertEqual(repo.revision, "main")
    }

    func testRepoBuildsHFURLs() {
        let repo = ModelStore.Repo(name: "eye", revision: "v1.0.0")
        XCTAssertEqual(
            repo.resolveBaseURL.absoluteString,
            "https://huggingface.co/desert-ant-labs/eye/resolve/v1.0.0")
        XCTAssertEqual(
            repo.treeURL.absoluteString,
            "https://huggingface.co/api/models/desert-ant-labs/eye/tree/v1.0.0")
    }

    func testVersionedNameKeysCacheByOid() {
        let name = ModelStore.versionedName("model.mlpackage", oidPrefix: "abc123def456")
        XCTAssertEqual(name, "model@abc123def456.mlpackage")
    }
}
