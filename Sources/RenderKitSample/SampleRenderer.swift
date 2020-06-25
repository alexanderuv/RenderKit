//
// Created by Alexander Ubillus on 4/11/20.
//

import Foundation
import RenderKit
import RenderKitCore

typealias Vertex = SIMD4<Float>

class SampleRenderer: RenderApplicationDelegate {
    private var device: Device!
    private var commandQueue: CommandQueue!
    private var vertexBuffer: VertexBuffer<Vertex>!
    private var indexBuffer: IndexBuffer!
    private var swapChain: SwapChain!
    private var pipeline: Pipeline!

    init() {
    }

    func initialize(_ platform: Platform, _ window: Window?) {
        device = try! platform.createDevice()
        guard let vertexBuffer = try? device.createVertexBuffer(withVertexType: Vertex.self, count: 3).get() else {
            fatalError("Error creating a vertexBuffer")
        }

        vertexBuffer.updateBuffer(contents: [
            [0.0,  1.0, 0.0, 1],
            [-1.0, -1.0, 0.0, 1],
            [1.0, -1.0, 0.0, 1]
        ])

        guard let indexBuffer = try? device.createIndexBuffer(withCount: 3).get() else {
            fatalError("Error creating an indexBuffer")
        }

        indexBuffer.updateBuffer(contents: [0, 1, 2])

        self.vertexBuffer = vertexBuffer
        self.indexBuffer = indexBuffer

        commandQueue = device.createCommandQueue()
        swapChain = device.createSwapChain(fromWindow: window!)

        var pipelineDesc = PipelineDescriptor()
        pipelineDesc.vertexShader = "basic_vertex"
        pipelineDesc.fragmentShader = "basic_fragment"
        pipelineDesc.colorAttachments[0].pixelFormat = .bgra8Unorm

        pipeline = device.createPipeline(descriptor: pipelineDesc)
    }

    func render() {
        let commandBuffer = commandQueue.createCommandBuffer()

        let rendered = commandBuffer.doRenderPass(on: self.swapChain) {

            commandBuffer.setPipeline(pipeline)

            commandBuffer.setVertexBuffer(vertexBuffer, offset: 0)
            commandBuffer.setIndexBuffer(indexBuffer)
            commandBuffer.drawIndexed(primitive: .triangle, indexCount: 3, indexOffset: 0)
        }

        if rendered {
            commandBuffer.submit()
        }
    }

    func finalize() {

    }
}
