//
// Created by Alexander Ubillus on 4/11/20.
//

import Foundation

public struct Color {
    
    private var rgba: SIMD4<Float>
    
    public var r: Float {
        rgba.x
    }
    
    public var g: Float {
        rgba.y
    }
    
    public var b: Float {
        rgba.z
    }
    
    public var a: Float {
        rgba.w
    }
    
    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.rgba = [red, green, blue, alpha]
    }

    public init(red: Float, green: Float, blue: Float) {
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public init(rgba: Vector4) {
        self.rgba = rgba
    }

    public init() {
        self = .white
    }

    public static let black = Color(red: 0, green: 0, blue: 0)
    public static let white = Color(red: 1, green: 1, blue: 1)
    public static let red = Color(red: 1, green: 0, blue: 0)
    public static let green = Color(red: 0, green: 1, blue: 0)
    public static let blue = Color(red: 0, green: 0, blue: 1)
    public static let cyan = Color(red: 0, green: 1, blue: 1)
    public static let magenta = Color(red: 1, green: 0, blue: 1)
    public static let noche = Color(red: 1, green: 1, blue: 0)
}
