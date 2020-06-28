//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation

open class VertexBuffer<T> {

    public init() {}

    open func updateBuffer(contents: [T]) {}

    open func unwrap() -> AnyObject? {
        nil
    }
}
//
//public protocol VertexBuffer {
//    associatedtype Vertex
//
//    func updateBuffer(contents: [Vertex])
//
//    func unwrap() -> AnyObject?
//}
