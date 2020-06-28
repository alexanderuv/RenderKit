//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Platform {
    func createWindow(_ configuration: WindowConfiguration) throws -> Window
}

func createPlatform(forBackend backend: Backend) throws -> Platform {
    #if os(macOS)
    return MacOSPlatform()
    #elseif os(Linux)
    return LinuxPlatform()
    #else
    fatalError("Unsupported platform")
    #endif
}
