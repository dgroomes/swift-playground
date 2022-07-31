// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "basic",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "basic", targets: ["basic"]),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "basic",
            dependencies: []),
    ]
)
