//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation

public protocol CommandBuffer {
    func doRenderPass(on swapChain: SwapChain, _ renderPass: () -> Void) -> Bool

    func setPipeline(_ pipeline: Pipeline)
    func setVertexBuffer<T: VertexBuffer<V>, V>(_ buffer: T, offset: Int)
    func setIndexBuffer(_ buffer: IndexBuffer)
    func drawIndexed(primitive: PrimitiveType, indexCount: Int, indexOffset: Int)
    func submit()
    func drawVertices(type: PrimitiveType, count: Int, offset: Int)
}
