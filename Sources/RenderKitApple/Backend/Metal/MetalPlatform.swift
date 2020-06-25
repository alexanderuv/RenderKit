//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import MetalKit
import RenderKitCore

public class PlatformMetal: Platform {

    public static func newObj() -> PlatformMetal {
        PlatformMetal()
    }

    public func createDevice() throws -> Device {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw RenderKitError.errorInitializingDriver
        }

        return MetalDevice(device)
    }
}
