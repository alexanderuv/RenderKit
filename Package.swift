// swift-tools-version:5.3

import PackageDescription

let package = Package(
        name: "RenderKit",
        platforms: [
            .macOS(.v10_15),
        ],
        products: [
            .library(name: "RenderKitStatic", type: .static, targets: ["RenderKit"]),
            .library(name: "RenderKitDynamic", type: .dynamic, targets: ["RenderKit"]),
            .executable(name: "RenderKitSample", targets: ["RenderKitSample"]),
        ],
        dependencies: [
            .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        ],
        targets: [
            .target(
                    name: "RenderKit",
                    dependencies: [
                        .product(name: "Logging", package: "swift-log"),
                        .target(name: "RenderKit-Apple", condition: .when(platforms: [.macOS, .iOS])),
                        .target(name: "RenderKit-Linux", condition: .when(platforms: [.linux])),
                        .target(name: "RenderKit-Windows", condition: .when(platforms: [.windows]))
                    ]),
            .target(
                    name: "RenderKit-Core"),
            .target(
                    name: "RenderKit-Apple",
                    dependencies: ["RenderKit-Core"]),
            .target(
                    name: "RenderKit-Linux",
                    dependencies: ["RenderKit-Core"]),
            .target(
                    name: "RenderKit-Windows",
                    dependencies: ["RenderKit-Core"]),
            .target(
                    name: "RenderKitSample",
                    dependencies: ["RenderKit"]),
            .testTarget(
                    name: "RenderKitTests",
                    dependencies: ["RenderKit"]),
        ]
)
