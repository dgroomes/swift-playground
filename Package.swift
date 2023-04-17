// swift-tools-version:5.8

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v13)
        ],
        products: [
            .executable(name: "SwiftPlayground", targets: ["SwiftPlayground"]),
        ],
        targets: [
            .executableTarget(
                    name: "SwiftPlayground",
                    dependencies: ["SwiftPlaygroundLogging", "SwiftPlaygroundConcurrency"]),
            .target(name: "SwiftPlaygroundLogging"),
            .target(name: "SwiftPlaygroundConcurrency")
        ]
)
