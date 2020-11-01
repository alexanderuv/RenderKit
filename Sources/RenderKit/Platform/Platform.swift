//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Platform {
    init()
    func createWindow(_ configuration: WindowConfiguration) throws -> Window
    func getHighResTime() -> Int
}

public func createPlatform() throws -> Platform {
    #if os(macOS)
    return MacOSPlatform()
    #elseif os(Linux)
    return LinuxPlatform()
    #else
    fatalError("Unsupported platform")
    #endif
}

extension Dictionary where Value: Hashable {
    func invert() -> [Value: Key] {
        var result = [Value: Key]()
        for (k, v) in self {
            result[v] = k
        }

        return result
    }
}
