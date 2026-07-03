# desert-ant-swift

Shared Swift core for the Desert Ant Labs SDKs. Every `<name>-swift` package depends on this one.

Two products.

- **`DesertAntUI`**: the [design-system][ds] tokens rendered as Swift: `DS.Color`, `DS.Font`, `DS.Space`, `DS.Radius`, `DS.Duration`, `DS.IOS`. Plus the shared demo pieces. `SwarmLoader`, `SectionLabel`, `StatLabel`, `CenterStatus`, `ProgressPanel`, `EmptyHint`. so every demo app looks like part of the same family without each SDK rewriting them.
- **`DesertAntStore`**: `ModelStore`, a small actor that downloads HuggingFace weights, caches them in Application Support, verifies SHA-256 against the LFS oid, and falls back to the newest cached copy when offline. Single source for the pattern across SDKs (generalized from `uhm`'s original `ModelDownloader`).

## Use

```swift
.package(url: "https://github.com/desert-ant-labs/desert-ant-swift", from: "0.1.0")
```

```swift
import DesertAntUI
import DesertAntStore

// 1. UI
Text("Eye")
    .font(DS.Font.display(38))
    .foregroundStyle(DS.Color.textPrimary)
    .padding(DS.Space.s5)

// 2. Weights. async, downloaded on first launch, cached after.
let store = ModelStore(.init(name: "eye"))
let mlpackage = try await store.archive(
    "eye-core.mlpackage.zip",
    unpackedAs: "eye-core.mlpackage",
    approxBytes: 27 * 1024 * 1024)
```

## Tokens vs. source of truth

The values in `Sources/DesertAntUI/DS+*.swift` mirror the CSS files in [`desert-ant-labs/design-system`][ds]. The CSS is canonical. When the brand changes there, port the new values here.

Brand fonts (Instrument Serif, Hanken Grotesk, JetBrains Mono) are not bundled. register them via `UIAppFonts` in the consuming app. The custom font names fall back to system serif / sans / mono so layouts hold while the brand face loads.

## Status

Pre-1.0. APIs may move while the first SDKs (`eye-swift`, `uhm-swift`, `clear-swift`) come online and put real pressure on the shape.

[ds]: https://github.com/desert-ant-labs/design-system

## License

[Desert Ant Labs Source-Available License](https://license.desertant.ai/1.0). Free for
most apps; a commercial license is required at scale. Full terms are at the link.
Licensing: <licensing@desertant.ai>.
