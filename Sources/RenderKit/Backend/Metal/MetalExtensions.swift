//
// Created by Alexander Ubillus on 3/30/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

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

extension BufferLayoutAttribute.DataType {
    func toMetal() -> MTLVertexFormat {
        switch self.format {
        case .float:
            switch self.count {
            case 1:
                return .float
            case 2:
                return .float2
            case 3:
                return .float3
            case 4:
                return .float4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        case .half:
            switch self.count {
            case 1:
                return .half
            case 2:
                return .half2
            case 3:
                return .half3
            case 4:
                return .half4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        case .uint:
            switch self.count {
            case 1:
                return .uint
            case 2:
                return .uint2
            case 3:
                return .uint3
            case 4:
                return .uint4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        case .int:
            switch self.count {
            case 1:
                return .int
            case 2:
                return .int2
            case 3:
                return .int3
            case 4:
                return .int4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        case .ushort:
            switch self.count {
            case 1:
                return .ushort
            case 2:
                return .ushort2
            case 3:
                return .ushort3
            case 4:
                return .ushort4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        case .short:
            switch self.count {
            case 1:
                return .short
            case 2:
                return .short2
            case 3:
                return .short3
            case 4:
                return .short4
            default:
                fatalError("Unsupported data type with format=\(self.format) and count=\(self.count)")
            }
        }
    }

}

#endif