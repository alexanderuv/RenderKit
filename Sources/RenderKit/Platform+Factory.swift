//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RKCore

#if os(macOS) || os(iOS)
import RKPlatform_Apple
#elseif os(Linux)
import RKPlatform_Linux
#elseif os(Windows)
import RKPlatform_Windows
#endif

public func createPlatform() throws -> some Platform {
    #if os(macOS)
    return MacOSPlatform()
    #elseif os(Linux)
    return LinuxPlatform()
    #elseif os(Windows)
    return WindowsPlatform()
    #else
    fatalError("Unsupported platform")
    #endif
}
