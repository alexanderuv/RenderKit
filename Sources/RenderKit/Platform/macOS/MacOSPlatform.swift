//
// Created by Alexander Ubillus on 3/27/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

public class MacOSPlatform: Platform {

    public func createWindow(_ configuration: WindowConfiguration) throws -> Window {
        CocoaWindow(configuration)
    }
}

#endif