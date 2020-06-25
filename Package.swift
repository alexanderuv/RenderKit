// swift-tools-version:5.2

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
//                        .target(name: "RenderKitApple", condition: .when(platforms: [.macOS, .iOS])),
//                        .target(name: "RenderKitLinux", condition: .when(platforms: [.linux])),
//                        .target(name: "RenderKitWindows", condition: .when(platforms: [.windows]))
                        .target(name: "RenderKitApple"),
                        .target(name: "RenderKitLinux"),
                        .target(name: "RenderKitWindows")
                    ]),
            .target(
                    name: "RenderKitCore"),
            .target(
                    name: "RenderKitApple",
                    dependencies: ["RenderKitCore"]),
            .target(
                    name: "RenderKitLinux",
                    dependencies: ["RenderKitCore"]),
            .target(
                    name: "RenderKitWindows",
                    dependencies: ["RenderKitCore"]),
            .target(
                    name: "RenderKitSample",
                    dependencies: ["RenderKit"]),
            .testTarget(
                    name: "RenderKitTests",
                    dependencies: ["RenderKit"]),
        ]
)
