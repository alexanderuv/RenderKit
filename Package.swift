// swift-tools-version:5.4

let package = Package(
        name: "RenderKit",
        platforms: [
            .macOS(.v10_15),
        ],
        products: [
//            .library(name: "RenderKitStatic", type: .static, targets: ["RenderKit"]),
            .library(name: "RenderKitDynamic", type: .dynamic, targets: ["RenderKit"]),
            .executable(name: "FadingTriangle", targets: ["FadingTriangle"]),
        ],
        dependencies: [
            .package(url: "https://github.com/apple/swift-log.git", from: "1.4.2"),
            .package(name: "SGLMath", url: "https://github.com/alexanderuv/Math.git", from: "3.1.0"),
            .package(name: "SwiftWin32", url: "https://github.com/compnerd/swift-win32", .branch("main")),
        ],
        targets: [
            .target(name: "RKCore", dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "SGLMath", package: "SGLMath")
            ]),
            .target(name: "RKPlatform_Apple", dependencies: [.byName(name: "RKCore")]),
            .target(name: "RKPlatform_Linux", dependencies: [.byName(name: "RKCore")]),
            .target(name: "RKPlatform_Windows", dependencies: [.byName(name: "RKCore"), .byName(name: "SwiftWin32")]),
            .target(name: "RKBackend_Metal", dependencies: [.byName(name: "RKCore"), .byName(name: "RKPlatform_Apple")]),
            .target(name: "RKBackend_Vulkan", dependencies: [.byName(name: "RKCore")]),
            .target(name: "RKBackend_DX12", dependencies: [.byName(name: "RKCore")]),
            .target(
                    name: "RenderKit",
                    dependencies: [
                        .byName(name: "RKPlatform_Apple", condition: .when(platforms: [.macOS, .iOS])),
                        .byName(name: "RKPlatform_Windows", condition: .when(platforms: [.windows])),
                        .byName(name: "RKPlatform_Linux", condition: .when(platforms: [.linux])),
                        .byName(name: "RKBackend_Metal", condition: .when(platforms: [.macOS, .iOS])),
                        .byName(name: "RKBackend_Vulkan", condition: .when(platforms: [.windows, .linux])),
                        .byName(name: "RKBackend_DX12", condition: .when(platforms: [.windows])),
                    ]),
            .executableTarget(
                    name: "FadingTriangle",
                    dependencies: ["RenderKit"],
                    path: "Samples/FadingTriangle"),
            .testTarget(
                    name: "RenderKitTests",
                    dependencies: ["RenderKit"]),
        ]
)

import PackageDescription

