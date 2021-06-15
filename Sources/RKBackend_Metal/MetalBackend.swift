//
// Created by Alexander Ubillus on 6/27/20.
//

import Foundation
import MetalKit
import RKCore

public class MetalBackend: BackendProtocol {
    public init() {
    }

    public func createDevice() throws -> Device {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw RenderKitError.errorInitializingDriver
        }

        return MetalDevice(device)
    }
}
