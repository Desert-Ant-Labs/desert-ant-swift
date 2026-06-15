# AGENTS.md — desert-ant-swift

Read [the org-wide AGENTS.md in `lab`](https://github.com/Desert-Ant-Labs/lab/blob/main/AGENTS.md) first. Repo-specific rules below.

> **Write for the next reader — human or agent.** Code, doc comments, the README, and tests all get read by people *and* by coding agents picking up the work later. Be clear, be specific, and don't lean on context that won't be there next session.

## What this repo is

The shared Swift core for every `<name>-swift` SDK in Desert Ant Labs. Two products:

- **`DesertAntUI`** — `DS.Color`, `DS.Font`, `DS.Space`, `DS.Radius`, `DS.Duration`, `DS.IOS`, plus the shared demo components (`SwarmLoader`, `SectionLabel`, `StatLabel`, `CenterStatus`, `ProgressPanel`, `EmptyHint`).
- **`DesertAntStore`** — `ModelStore`: HuggingFace tree-API + Application Support cache + SHA-256 verification against LFS oid + offline fallback.

## Rules

- **Apple-native first.** Follow current Apple/Swift best practices — structured concurrency (`async`/`await`, actors, `Task`), `Observable` over `ObservableObject` where iOS 17+ allows, value types by default, SwiftUI primitives over UIKit wrappers, `FileManager`/`URLSession`/`CryptoKit` over hand-rolled equivalents. Reach for the platform class before writing your own. A developer using these SDKs should feel they're using a natural extension of Apple's own frameworks, not a parallel universe.
- **`DS.*` values mirror `design-system/tokens/*.css`.** That repo is the source of truth — never invent a new color or spacing value here; port it. If a token is missing, fix it in `design-system` first.
- **One shared `ModelStore`.** When an SDK needs new download behavior (resumable downloads, sharded files, signed URLs), extend `ModelStore` here, don't fork it in the SDK. The whole point of this repo is that every SDK has one path for weights.
- **Two products stay independent.** `DesertAntUI` does not depend on `DesertAntStore` and vice versa. A consumer can pull only what it needs.
- **Platform targets:** iOS 17+ / macOS 14+ / tvOS 17+ / visionOS 1+. Don't add older targets without a reason in the PR.
- **Brand fonts (Instrument Serif, Hanken Grotesk, JetBrains Mono) are not bundled.** Custom-font names in `DS.Font` fall back to system serif / sans / mono. Consuming apps register the fonts via `UIAppFonts`.
- **Comments.** Same as the org rule in `lab/AGENTS.md`: default to none, earn them via the *why*. The doc comments already on `ModelStore` and the token files explain non-obvious behavior (HF content-addressing, the offline fallback, brand intent) — keep that voice. Don't add line comments restating what a constant is.

## Verifying changes

- `swift build` and `swift test` must pass before pushing.
- If you change a `DS.*` value, the demo apps in every `<name>-swift` repo will absorb it on next dependency resolve — be intentional.
