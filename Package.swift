// swift-tools-version:5.5

import PackageDescription

let package = Package(
        name: "swift-playground",
        platforms: [
            .macOS(.v12)
        ],
        products: [
            .executable(name: "SwiftPlayground", targets: ["SwiftPlayground"]),
        ],
        targets: [
            .executableTarget(
                    name: "SwiftPlayground",
                    dependencies: ["File", "Process"]),
            .target(name: "File"),
            .target(name: "Process")
        ]
)
