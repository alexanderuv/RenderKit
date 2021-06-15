//
// Created by Alexander Ubillus on 7/14/20.
//

import Foundation
import SGLMath

fileprivate let π = Float.pi

extension Float {
    public func toDegrees() -> Self {
        self * 180 / π
    }
    
    public func toRadians() -> Self {
        self * π / 180
    }
}
//
extension Mat4 {

    public static let zero = Mat4(0)
    public static let identity = Mat4(1)

    public func rotate(degrees: Float) -> Mat4 {
        SGLMath.rotate(self, degrees, Vec3(1))
    }

    public func rotateZ(degrees: Float) -> Mat4 {
        SGLMath.rotate(self, degrees, [0,0,1])
    }

//    public static let identity = Mat4(diagonal: [1, 1, 1, 1])
//
//    public func rotate(degrees: Vec3) -> Mat4 {
//        let xRad = degrees.x.toRadians()
//        let yRad = degrees.y.toRadians()
//        let zRad = degrees.z.toRadians()
//
//        return rotate(radians: [xRad, yRad, zRad])
//    }
//
//    public func rotate(radians: Vec3) -> Mat4 {
//        let yaw = Mat4([
//            [cos(radians.z), -sin(radians.z), 0, 0],
//            [-sin(radians.z), cos(radians.z), 0, 0],
//            [0, 0, 1, 0],
//            [0, 0, 0, 1]
//        ])
//        let pitch = Mat4([
//            [cos(radians.y), 0, -sin(radians.y), 0],
//            [0, 1, 0, 0],
//            [sin(radians.y), 0, cos(radians.y), 0],
//            [0, 0, 0, 1]
//        ])
//        let roll = Mat4([
//            [1, 0, 0, 0],
//            [0, cos(radians.x), sin(radians.x), 0],
//            [0, -sin(radians.x), cos(radians.x), 0],
//            [0, 0, 0, 1]
//        ])
//
//        return yaw * pitch * roll * self
//    }
//
//    public func rotateX(degrees: Float) -> Mat4 {
//        return rotateX(radians: degrees.toRadians())
//    }
//
//    public func rotateX(radians: Float) -> Mat4 {
//        return Mat4(rotationX: radians) * self
//    }
//
//    public func rotateY(degrees: Float) -> Mat4 {
//        return rotateY(radians: degrees.toRadians())
//    }
//
//    public func rotateY(radians: Float) -> Mat4 {
//        return Mat4(rotationY: radians) * self
//    }
//
//    public func rotateZ(degrees: Float) -> Mat4 {
//        return rotateZ(radians: degrees.toRadians())
//    }
//
//    public func rotateZ(radians: Float) -> Mat4 {
//        return Mat4(rotationZ: radians) * self
//    }
//
//    public func translate(x: Float) -> Mat4 {
//        return Mat4(translation: [x, 0, 0]) * self
//    }
//
//    public func translate(y: Float) -> Mat4 {
//        return Mat4(translation: [0, y, 0]) * self
//    }
//
//    public func translate(z: Float) -> Mat4 {
//        return Mat4(translation: [0, 0, z]) * self
//    }
//
//    public func translate(xyz: Vec3) -> Mat4 {
//        return Mat4(translation: xyz) * self
//    }
//
//    public init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
//        let y = 1 / tan(fov * 0.5)
//        let x = y / aspect
//        let z = lhs ? far / (far - near) : far / (near - far)
//        let X = Vector4( x,  0,  0,  0)
//        let Y = Vector4( 0,  y,  0,  0)
//        let Z = lhs ? Vector4( 0,  0,  z, 1) : Vector4( 0,  0,  z, -1)
//        let W = lhs ? Vector4( 0,  0,  z * -near,  0) : Vector4( 0,  0,  z * near,  0)
//        self.init()
//        columns = (X, Y, Z, W)
//    }
//
//    public init(translation: Vec3) {
//      let matrix = Mat4(
//        [            1,             0,             0, 0],
//        [            0,             1,             0, 0],
//        [            0,             0,             1, 0],
//        [translation.x, translation.y, translation.z, 1]
//      )
//      self = matrix
//    }
//
//    public init(scale: Vec3) {
//      let matrix = Mat4(
//        [scale.x,         0,         0, 0],
//        [        0, scale.y,         0, 0],
//        [        0,       0,   scale.z, 0],
//        [        0,       0,         0, 1]
//      )
//      self = matrix
//    }
//
//    public init(rotationX radians: Float) {
//      let matrix = Mat4(
//        [1,           0,          0, 0],
//        [0,  cos(radians), sin(radians), 0],
//        [0, -sin(radians), cos(radians), 0],
//        [0,           0,          0, 1]
//      )
//      self = matrix
//    }
//
//    public init(rotationY radians: Float) {
//      let matrix = Mat4(
//        [cos(radians), 0, -sin(radians), 0],
//        [         0, 1,           0, 0],
//        [sin(radians), 0,  cos(radians), 0],
//        [         0, 0,           0, 1]
//      )
//      self = matrix
//    }
//
//    public init(rotationZ radians: Float) {
//      let matrix = Mat4(
//        [ cos(radians), sin(radians), 0, 0],
//        [-sin(radians), cos(radians), 0, 0],
//        [          0,          0, 1, 0],
//        [          0,          0, 0, 1]
//      )
//      self = matrix
//    }
//
//    public init(rotation radiansVector: Vec3) {
//      let rotationX = Mat4(rotationX: radiansVector.x)
//      let rotationY = Mat4(rotationY: radiansVector.y)
//      let rotationZ = Mat4(rotationZ: radiansVector.z)
//      self = rotationX * rotationY * rotationZ
//    }
}
