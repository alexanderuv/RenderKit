// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
//                        .product(name: "NIO", package: "swift-nio")
                    ]),
            .target(
                    name: "RenderKitSample",
                    dependencies: ["RenderKit"]),
            .testTarget(
                    name: "RenderKitTests",
                    dependencies: ["RenderKit"]),
        ]
)
