//
// Created by Alexander Ubillus on 6/27/20.
//

import Foundation

public protocol BackendProtocol {
    func createDevice() throws -> Device
}

public enum Backend {
    case platformDefault
    case metal
    case directX12
    case vulkan
}

extension Backend {
    public func createBackend(forPlatform platform: Platform, configuration: EngineConfiguration) -> BackendProtocol {
        switch self {
        case .platformDefault:
            #if os(macOS)

            return MetalBackend()

            #elseif os(Linux)

            // could be opengl or vulkan
            return VulkanBackend()

            #else
            fatalError("Can't find a default backend for platform \(platform)")
            #endif
        case .metal:
            #if os(macOS) || os(iOS)
            return MetalBackend()
            #else
            fatalError("Can't use Metal backend on this platform")
            #endif
        case .vulkan:
            #if os(Linux) || os(Windows)
            return VulkanBackend()
            #else
            fatalError("Can't use Vulkan backend on this platform")
            #endif
        case .directX12:
            #if os(Windows)
            return DX12Backend()
            #else
            fatalError("Can't use DirectX12 backend on this platform")
            #endif
        }
    }
}
