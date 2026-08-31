// swift-tools-version: 5.10
import PackageDescription

// The Desert Ant Labs brand kit: the bare minimum to build a SwiftUI demo
// app in the brand. One product, no dependencies.
let package = Package(
    name: "desert-ant-swift",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "DesertAntUI", targets: ["DesertAntUI"]),
    ],
    targets: [
        .target(name: "DesertAntUI", path: "Sources/DesertAntUI"),
        .testTarget(name: "DesertAntUITests", dependencies: ["DesertAntUI"], path: "Tests/DesertAntUITests"),
    ]
)
