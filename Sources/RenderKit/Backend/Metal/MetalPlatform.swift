//
// Created by Alexander Ubillus on 3/27/20.
//

#if os(macOS) || os(iOS)
import Foundation
import MetalKit

class PlatformMetal: Platform {

    func createDevice() throws -> Device {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw RenderKitError.errorInitializingDriver
        }

        return MetalDevice(device)
    }
}

#endif
