//
// Created by Alexander Ubillus on 7/14/20.
//

import Foundation
import simd

public typealias Vector3 = SIMD3<Float>
public typealias Vector4 = SIMD4<Float>
public typealias Matrix4x4 = simd_float4x4

fileprivate let π = Float.pi

extension Float {
    public func toDegrees() -> Self {
        self * 180 / π
    }
    
    public func toRadians() -> Self {
        self * π / 180
    }
}

extension Matrix4x4 {
    public static let identity = Matrix4x4(diagonal: [1, 1, 1, 1])
    public static let zero = Matrix4x4(0)
    
    public func rotate(degrees: Vector3) -> Matrix4x4 {
        let xRad = degrees.x.toRadians()
        let yRad = degrees.y.toRadians()
        let zRad = degrees.z.toRadians()
        
        return rotate(radians: [xRad, yRad, zRad])
    }
    
    public func rotate(radians: Vector3) -> Matrix4x4 {
        let yaw = Matrix4x4([
            [cos(radians.z), -sin(radians.z), 0, 0],
            [-sin(radians.z), cos(radians.z), 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ])
        let pitch = Matrix4x4([
            [cos(radians.y), 0, -sin(radians.y), 0],
            [0, 1, 0, 0],
            [sin(radians.y), 0, cos(radians.y), 0],
            [0, 0, 0, 1]
        ])
        let roll = Matrix4x4([
            [1, 0, 0, 0],
            [0, cos(radians.x), sin(radians.x), 0],
            [0, -sin(radians.x), cos(radians.x), 0],
            [0, 0, 0, 1]
        ])
        
        return yaw * pitch * roll * self
    }
    
    public func rotateX(degrees: Float) -> Matrix4x4 {
        return rotateX(radians: degrees.toRadians())
    }
    
    public func rotateX(radians: Float) -> Matrix4x4 {
        return Matrix4x4(rotationX: radians) * self
    }
    
    public func rotateY(degrees: Float) -> Matrix4x4 {
        return rotateY(radians: degrees.toRadians())
    }
    
    public func rotateY(radians: Float) -> Matrix4x4 {
        return Matrix4x4(rotationY: radians) * self
    }
    
    public func rotateZ(degrees: Float) -> Matrix4x4 {
        return rotateZ(radians: degrees.toRadians())
    }
    
    public func rotateZ(radians: Float) -> Matrix4x4 {
        return Matrix4x4(rotationZ: radians) * self
    }
    
    public func translate(x: Float) -> Matrix4x4 {
        return Matrix4x4(translation: [x, 0, 0]) * self
    }
    
    public func translate(y: Float) -> Matrix4x4 {
        return Matrix4x4(translation: [0, y, 0]) * self
    }
    
    public func translate(z: Float) -> Matrix4x4 {
        return Matrix4x4(translation: [0, 0, z]) * self
    }
    
    public func translate(xyz: Vector3) -> Matrix4x4 {
        return Matrix4x4(translation: xyz) * self
    }
    
    public init(projectionFov fov: Float, near: Float, far: Float, aspect: Float, lhs: Bool = true) {
        let y = 1 / tan(fov * 0.5)
        let x = y / aspect
        let z = lhs ? far / (far - near) : far / (near - far)
        let X = Vector4( x,  0,  0,  0)
        let Y = Vector4( 0,  y,  0,  0)
        let Z = lhs ? Vector4( 0,  0,  z, 1) : Vector4( 0,  0,  z, -1)
        let W = lhs ? Vector4( 0,  0,  z * -near,  0) : Vector4( 0,  0,  z * near,  0)
        self.init()
        columns = (X, Y, Z, W)
    }
    
    public init(translation: Vector3) {
      let matrix = Matrix4x4(
        [            1,             0,             0, 0],
        [            0,             1,             0, 0],
        [            0,             0,             1, 0],
        [translation.x, translation.y, translation.z, 1]
      )
      self = matrix
    }
    
    public init(scale: Vector3) {
      let matrix = Matrix4x4(
        [scale.x,         0,         0, 0],
        [        0, scale.y,         0, 0],
        [        0,       0,   scale.z, 0],
        [        0,       0,         0, 1]
      )
      self = matrix
    }
    
    public init(rotationX radians: Float) {
      let matrix = Matrix4x4(
        [1,           0,          0, 0],
        [0,  cos(radians), sin(radians), 0],
        [0, -sin(radians), cos(radians), 0],
        [0,           0,          0, 1]
      )
      self = matrix
    }
    
    public init(rotationY radians: Float) {
      let matrix = Matrix4x4(
        [cos(radians), 0, -sin(radians), 0],
        [         0, 1,           0, 0],
        [sin(radians), 0,  cos(radians), 0],
        [         0, 0,           0, 1]
      )
      self = matrix
    }
    
    public init(rotationZ radians: Float) {
      let matrix = Matrix4x4(
        [ cos(radians), sin(radians), 0, 0],
        [-sin(radians), cos(radians), 0, 0],
        [          0,          0, 1, 0],
        [          0,          0, 0, 1]
      )
      self = matrix
    }
    
    public init(rotation radiansVector: Vector3) {
      let rotationX = Matrix4x4(rotationX: radiansVector.x)
      let rotationY = Matrix4x4(rotationY: radiansVector.y)
      let rotationZ = Matrix4x4(rotationZ: radiansVector.z)
      self = rotationX * rotationY * rotationZ
    }
}
