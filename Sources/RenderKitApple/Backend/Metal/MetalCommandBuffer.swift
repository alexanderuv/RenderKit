//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation
import MetalKit
import RenderKitCore

class MetalCommandBuffer: CommandBuffer {

    let nativeBuffer: MTLCommandBuffer
    var currentIndexBuffer: MetalIndexBuffer? = nil
    var currentSwapChain: MetalSwapChain? = nil
    var commandEncoder: MTLRenderCommandEncoder? = nil
    var clearColor: Color = .black

    public init(nativeBuffer: MTLCommandBuffer) {
        self.nativeBuffer = nativeBuffer
    }

    func doRenderPass(on swapChain: SwapChain, _ renderPass: () -> Void) -> Bool {
        guard let swapChain = swapChain as? MetalSwapChain else {
            fatalError("Expecting MetalSwapChain but got something else")
        }

        self.currentSwapChain = swapChain

        guard let drawable = swapChain.metalLayer.nextDrawable() else {
//                fatalError("Unable to get next drawable from metal layer")
            return false
        }

        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = drawable.texture
        descriptor.colorAttachments[0].loadAction = .clear
        descriptor.colorAttachments[0].clearColor = clearColor.toMetal()

        if let encoder = nativeBuffer.makeRenderCommandEncoder(descriptor: descriptor) {
            self.commandEncoder = encoder
            renderPass()

            encoder.endEncoding()

            return true
        }

        return false
    }

    func setPipeline(_ pipeline: Pipeline) {
        guard let pipeline = pipeline as? MetalPipeline else {
            fatalError("Expecting MetalSwapChain but got something else")
        }

        guard let encoder = self.commandEncoder else {
            fatalError("Attempting to call setPipeline outside before calling beginRenderPass")
        }

        encoder.setRenderPipelineState(pipeline.pipelineState)
    }

    func submit() {
        if let drawable = self.currentSwapChain!.metalLayer.nextDrawable() {
            self.nativeBuffer.present(drawable)
            self.nativeBuffer.commit()
        }
    }

    func setVertexBuffer<T: VertexBuffer<V>, V>(_ buffer: T, offset: Int) {
        guard let buffer = buffer.unwrap() as? MTLBuffer else {
            fatalError("Expecting MetalSwapChain but got something else")
        }

        guard let encoder = self.commandEncoder else {
            fatalError("Attempting to call setPipeline outside before calling beginRenderPass")
        }

        encoder.setVertexBuffer(buffer, offset: offset, index: 0)
    }

    func setIndexBuffer(_ buffer: IndexBuffer) {
        guard self.commandEncoder != nil else {
            fatalError("Attempting to call setPipeline outside before calling beginRenderPass")
        }

        guard let buffer = buffer as? MetalIndexBuffer else {
            fatalError("Expecting MetalSwapChain but got something else")
        }

        self.currentIndexBuffer = buffer
    }

    func drawVertices(type: PrimitiveType, count: Int, offset: Int) {
        guard let encoder = self.commandEncoder else {
            fatalError("Attempting to call setPipeline outside before calling beginRenderPass")
        }

        encoder.drawPrimitives(type: type.toMetal(), vertexStart: offset, vertexCount: count)
    }

    func drawIndexed(primitive: PrimitiveType, indexCount: Int, indexOffset: Int) {
        guard let encoder = self.commandEncoder else {
            fatalError("Attempting to call setPipeline outside before calling beginRenderPass")
        }

        guard let indexBuffer = self.currentIndexBuffer else {
            fatalError("Attempting to call drawIndexed without having set an index buffer")
        }

        encoder.drawIndexedPrimitives(type: primitive.toMetal(),
                indexCount: indexCount,
                indexType: .uint16,
                indexBuffer: indexBuffer.hwBuffer,
                indexBufferOffset: indexOffset)
    }
}
