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
            .executable(name: "SwiftPlaygroundActors", targets: ["SwiftPlaygroundActors"]),
        ],
        targets: [
            .executableTarget(name: "SwiftPlaygroundFileLogging"),
            .executableTarget(name: "SwiftPlaygroundAsyncAwait"),
            .executableTarget(name: "SwiftPlaygroundActors")
        ]
)
