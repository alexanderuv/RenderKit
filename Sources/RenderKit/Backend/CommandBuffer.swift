//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation

public protocol CommandBuffer {
    func doRenderPass(on swapChain: SwapChain, _ renderPass: () -> Void) -> Bool

    func setPipeline(_ pipeline: Pipeline)
    func setVertexBuffer(_ buffer: VertexBuffer, offset: Int)
    func setIndexBuffer(_ buffer: IndexBuffer)
    func setUniforms<T>(_ uniforms: T, slot: Int, stage: StageFlags)
    func drawIndexed(primitive: PrimitiveType, indexCount: Int, indexOffset: Int)
    func drawVertices(type: PrimitiveType, count: Int, offset: Int)
}
