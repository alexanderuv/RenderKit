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

    public static func from<T>(struct: T.Type) {
        let x = Mirror(reflecting: `struct`)
        print(x)
        print(Mirror(reflecting: SIMD3<Float>()))
    }

    public static let position3d = BufferLayout(attributes: [
        BufferLayoutAttribute(dataType: .float3, name: "position")
    ], stride: MemoryLayout<SIMD3<Float>>.stride)

    public static let position3dAndColor = BufferLayout(attributes: [
        BufferLayoutAttribute(dataType: .float3, name: "position"),
        BufferLayoutAttribute(dataType: .float4, name: "color")
    ], stride: MemoryLayout<SIMD3<Float>>.stride)

    public static let position2d = BufferLayout(attributes: [
        BufferLayoutAttribute(dataType: .float2, name: "position")
    ], stride: MemoryLayout<SIMD3<Float>>.stride)

    public static let position2dAndColor = BufferLayout(attributes: [
        BufferLayoutAttribute(dataType: .float2, name: "position"),
        BufferLayoutAttribute(dataType: .float4, name: "color")
    ], stride: MemoryLayout<SIMD3<Float>>.stride)
}

public struct BufferLayoutAttribute {

    public enum DataFormat {
        case float,
             half,
             int,
             short,
             uint,
             ushort
    }

    public struct DataType {

        public let format: DataFormat
        public let count: Int
        public var size: Int {
            get {
                let base: Int
                switch self.format {

                case .float, .int, .uint:
                    base = MemoryLayout<Int32>.size
                case .ushort, .short, .half:
                    base = MemoryLayout<Int16>.size
                }

                return base * count
            }
        }

        private init(format: DataFormat, count: Int) {
            self.format = format
            self.count = count
        }

        public static let float2 = DataType(format: .float, count: 2)
        public static let float3 = DataType(format: .float, count: 3)
        public static let float4 = DataType(format: .float, count: 4)
    }

    public let dataType: DataType
    public let name: String

    public init(dataType: DataType, name: String) {
        self.dataType = dataType
        self.name = name
    }
}

public protocol VertexBuffer {
    func updateBuffer<T>(contents: [T])
    func unwrap() -> Any?
}