//
// Created by alexander on 6/14/2021.
//

import Foundation
import RKCore

#if os(macOS) || os(iOS)
import RKBackend_Metal
#elseif os(Windows)
import RKBackend_Vulkan
import RKBackend_DX12
#endif

extension Backend {
    public func createBackend(forPlatform platform: Platform) -> BackendProtocol {
        switch self {
        case .platformDefault:
            #if os(macOS)

            return MetalBackend()

            #elseif os(Windows)

            return DX12Backend()

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