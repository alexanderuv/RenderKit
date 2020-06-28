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
            .executable(name: "SampleApp", targets: ["SampleApp"]),
        ],
        dependencies: [
            .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        ],
        targets: [
            .target(
                    name: "RenderKit",
                    dependencies: [
                        .product(name: "Logging", package: "swift-log")
                    ]),
            .target(
                    name: "SampleApp",
                    dependencies: ["RenderKit"]),
            .testTarget(
                    name: "RenderKitTests",
                    dependencies: ["RenderKit"]),
        ]
)
