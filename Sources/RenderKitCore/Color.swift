//
// Created by Alexander Ubillus on 4/11/20.
//

import Foundation

public struct Color {
    public var r: Float = 0
    public var g: Float = 0
    public var b: Float = 0
    public var a: Float = 0

    public init(red: Float, green: Float, blue: Float, alpha: Float) {
        self.r = red
        self.g = green
        self.b = blue
        self.a = alpha
    }

    public init(red: Float, green: Float, blue: Float) {
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }

    public init() {
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
