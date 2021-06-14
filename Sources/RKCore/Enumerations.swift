//
// Created by Alexander Ubillus on 4/11/20.
//

import Foundation

public enum PrimitiveType {
    case triangle
    case triangleStrip
    case line
    case lineStrip
    case point
}

public enum RenderKitError: Error {
    case backendNotSupportedInThisPlatform
    case unsupportedPlatform
    case errorInitializingDriver
    case errorCreatingNativeWindow
    case errorCreatingHardwareBuffer
}

public struct StageFlags: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let vertex = StageFlags(rawValue: 1 << 0)
    public static let fragment = StageFlags(rawValue: 1 << 1)
    
    public static let all: StageFlags = [.vertex, .fragment]
}
