//
// Created by Alexander Ubillus on 6/27/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

class MetalBackend: BackendProtocol {
    public func createDevice() throws -> Device {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw RenderKitError.errorInitializingDriver
        }

        return MetalDevice(device)
    }
}

#endif