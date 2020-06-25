//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RenderKitCore
import RenderKitApple

func createPlatform(forBackend backend: Backend) throws -> Platform {
    switch backend {
    case .platformDefault:
        #if os(macOS) || os(iOS)
        return PlatformMetal.newObj()
        #else
        throw RenderKitError.unsupportedPlatform
        #endif
    case .metal:
        #if os(macOS) || os(iOS)
        return PlatformMetal.newObj()
        #else
        throw RenderKitError.unsupportedPlatform
        #endif
//    case .vulkan:
//        return PlatformVulkan()
    default:
        throw RenderKitError.unsupportedPlatform
    }
}
