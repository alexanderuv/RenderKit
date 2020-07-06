//
// Created by Alexander Ubillus on 3/29/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

class MetalPipeline: Pipeline {
    let pipelineState: MTLRenderPipelineState
    let shaderLibrary: MTLLibrary

    init(_ device: MTLDevice, _ descriptor: PipelineDescriptor) {
        guard let shaderLibrary = try? device.makeLibrary(source: descriptor.shader.content, options: .none) else {
            fatalError("Unable to create MTLLibrary")
        }

        self.shaderLibrary = shaderLibrary
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        let vertexProgram = shaderLibrary.makeFunction(name: descriptor.shader.vertexFunction)
        let fragmentProgram = shaderLibrary.makeFunction(name: descriptor.shader.fragmentFunction)

        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.vertexDescriptor = MetalPipeline.mapVertexLayout(descriptor.vertexLayout)
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = descriptor.colorAttachments[0].pixelFormat.toMetal()

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }

    private static func mapVertexLayout(_ layout: BufferLayout) -> MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        var i = 0
        var currentOffset = 0
        for att in layout.attributes {
            vertexDescriptor.attributes[i].format = att.dataType.toMetal()
            vertexDescriptor.attributes[i].bufferIndex = 0
            vertexDescriptor.attributes[i].offset = currentOffset

            currentOffset += att.dataType.size
            i += 1
        }
        vertexDescriptor.layouts[0].stride = layout.stride
        vertexDescriptor.layouts[0].stepFunction = .perVertex

        return vertexDescriptor
    }
}

#endif
