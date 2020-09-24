//
// Created by Alexander Ubillus on 7/14/20.
//

import Foundation
import simd

public typealias Vector3 = SIMD3<Float>
public typealias Matrix4x4 = simd_float4x4

func radiansToDegrees<T>(_ number: T) -> T where T: FloatingPoint {
    number * 180 / .pi
}

func degreesToRadians<T>(_ number: T) -> T where T: FloatingPoint {
    number * .pi / 180
}

extension Matrix4x4 {
    public static let identity = Matrix4x4(diagonal: [1, 1, 1, 1])
    public static let zero = Matrix4x4(0)
    
    public func rotate(degrees: Vector3) -> Matrix4x4 {
        let xRad = degreesToRadians(degrees.x)
        let yRad = degreesToRadians(degrees.y)
        let zRad = degreesToRadians(degrees.z)
        
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
        return rotateX(radians: degreesToRadians(degrees))
    }
    
    public func rotateX(radians: Float) -> Matrix4x4 {
        return Matrix4x4([
            [1, 0, 0, 0],
            [0, cos(radians), sin(radians), 0],
            [0, -sin(radians), cos(radians), 0],
            [0, 0, 0, 1]
        ]) * self
    }
    
    
    public func rotateY(degrees: Float) -> Matrix4x4 {
        return rotateY(radians: degreesToRadians(degrees))
    }
    
    public func rotateY(radians: Float) -> Matrix4x4 {
        return Matrix4x4([
            [cos(radians), 0, -sin(radians), 0],
            [0, 1, 0, 0],
            [sin(radians), 0, cos(radians), 0],
            [0, 0, 0, 1]
        ]) * self
    }
    
    public func rotateZ(degrees: Float) -> Matrix4x4 {
        return rotateZ(radians: degreesToRadians(degrees))
    }
    
    public func rotateZ(radians: Float) -> Matrix4x4 {
        return Matrix4x4([
            [cos(radians), -sin(radians), 0, 0],
            [-sin(radians), cos(radians), 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        ]) * self
    }
}
