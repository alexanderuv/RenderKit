//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation

public struct BufferLayout {
    public let attributes: [BufferLayoutAttribute]
    public let stride: Int

    public init(attributes: [BufferLayoutAttribute], stride: Int) {
        self.attributes = attributes
        self.stride = stride
    }
}

public struct BufferLayoutAttribute {

    public enum DataFormat {
        case float, float2, float3, float4,
             int, int2, int3, int4,
             short, short2, short3, short4,
             uint, uint2, uint3, uint4,
             ushort, ushort2, ushort3, ushort4

        internal static func strideOf(_ format: DataFormat) -> Int {
            switch format {
            case .float: return MemoryLayout<Float>.stride
            case .float2: return MemoryLayout<SIMD2<Float>>.stride
            case .float3: return MemoryLayout<SIMD3<Float>>.stride
            case .float4: return MemoryLayout<SIMD3<Float>>.stride
                
            case .int: return MemoryLayout<Int>.stride
            case .int2: return MemoryLayout<SIMD2<Int>>.stride
            case .int3: return MemoryLayout<SIMD3<Int>>.stride
            case .int4: return MemoryLayout<SIMD3<Int>>.stride
                
            case .short: return MemoryLayout<Int16>.stride
            case .short2: return MemoryLayout<SIMD2<Int16>>.stride
            case .short3: return MemoryLayout<SIMD3<Int16>>.stride
            case .short4: return MemoryLayout<SIMD3<Int16>>.stride
                
            case .uint: return MemoryLayout<UInt>.stride
            case .uint2: return MemoryLayout<SIMD2<UInt>>.stride
            case .uint3: return MemoryLayout<SIMD3<UInt>>.stride
            case .uint4: return MemoryLayout<SIMD3<UInt>>.stride
                
            case .ushort: return MemoryLayout<UInt16>.stride
            case .ushort2: return MemoryLayout<SIMD2<UInt16>>.stride
            case .ushort3: return MemoryLayout<SIMD3<UInt16>>.stride
            case .ushort4: return MemoryLayout<SIMD3<UInt16>>.stride
            }
        }
    }

    public let format: DataFormat
    public let stride: Int
    public let name: String

    public init(name: String, format: DataFormat) {
        self.name = name
        self.format = format
        self.stride = DataFormat.strideOf(format)
    }
}

public protocol VertexBuffer {
    func updateBuffer<T>(contents: [T])
    func unwrap() -> Any?
}
