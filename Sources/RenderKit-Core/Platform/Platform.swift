//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Platform {
    func createDevice() throws -> Device
}

func createPlatform(forBackend backend: Backend) throws -> Platform {
    switch backend {
    case .platformDefault:
        #if os(macOS) || os(iOS)
        return PlatformMetal()
        #else
        throw RenderKitError.unsupportedPlatform
        #endif
    case .metal:
        #if os(macOS) || os(iOS)
        return PlatformMetal()
        #else
        throw RenderKitError.unsupportedPlatform
        #endif
    case .vulkan:
        return PlatformVulkan()
    default:
        throw RenderKitError.unsupportedPlatform
    }
}
