//
// Created by Alexander Ubillus on 3/30/20.
//

#if os(macOS) || os(iOS)
import Foundation
import MetalKit
import RenderKitCore

extension PixelFormat {
    func toMetal() -> MTLPixelFormat {
        switch self {
        case .bgra8Unorm:
            return .bgra8Unorm
        }
    }
}

extension PrimitiveType {
    func toMetal() -> MTLPrimitiveType {
        switch self {
        case .triangle:
            return .triangle
        case .line:
            return .line
        case .point:
            return .point
        case .lineStrip:
            return .lineStrip
        case .triangleStrip:
            return .triangleStrip
        }
    }
}

extension Color {
    func toMetal() -> MTLClearColor {
        MTLClearColorMake(Double(self.r), Double(self.g), Double(self.b), Double(self.a))
    }
}

#endif