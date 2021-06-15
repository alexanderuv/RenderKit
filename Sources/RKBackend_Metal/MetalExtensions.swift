//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation
import MetalKit
import RKCore

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

extension BufferLayoutAttribute.DataFormat {
    func toMetal() -> MTLVertexFormat {
        switch self {
        case .float: return .float
        case .float2: return .float2
        case .float3: return .float3
        case .float4: return .float4
        case .int: return .int
        case .int2: return .int2
        case .int3: return .int3
        case .int4: return .int4
        case .short: return .short
        case .short2: return .short2
        case .short3: return .short3
        case .short4: return .short4
        case .uint: return .uint
        case .uint2: return .uint2
        case .uint3: return .uint3
        case .uint4: return .uint4
        case .ushort: return .ushort
        case .ushort2: return .ushort2
        case .ushort3: return .ushort3
        case .ushort4: return .ushort4
        }
    }

}
