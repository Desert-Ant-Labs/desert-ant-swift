// swift-tools-version: 5.10
import PackageDescription

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
        .library(name: "DesertAntStore", targets: ["DesertAntStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", from: "0.9.19"),
        .package(url: "https://github.com/huggingface/swift-transformers.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "DesertAntUI",
            path: "Sources/DesertAntUI"
        ),
        .target(
            name: "DesertAntStore",
            dependencies: [
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
                .product(name: "Hub", package: "swift-transformers"),
            ],
            path: "Sources/DesertAntStore"
        ),
        .testTarget(
            name: "DesertAntUITests",
            dependencies: ["DesertAntUI"],
            path: "Tests/DesertAntUITests"
        ),
        .testTarget(
            name: "DesertAntStoreTests",
            dependencies: ["DesertAntStore"],
            path: "Tests/DesertAntStoreTests"
        ),
    ]
)
