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

