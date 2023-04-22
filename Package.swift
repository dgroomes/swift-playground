// swift-tools-version:5.8

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v13)
        ],
        products: [
            .executable(name: "SwiftPlaygroundFileLogging", targets: ["SwiftPlaygroundFileLogging"]),
            .executable(name: "SwiftPlaygroundAsyncAwait", targets: ["SwiftPlaygroundAsyncAwait"]),
        ],
        targets: [
            .executableTarget(name: "SwiftPlaygroundFileLogging"),
            .executableTarget(name: "SwiftPlaygroundAsyncAwait")
        ]
)
