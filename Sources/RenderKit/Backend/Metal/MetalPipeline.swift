//
// Created by Alexander Ubillus on 3/29/20.
//

#if os(macOS) || os(iOS)
import Foundation
import MetalKit

let defaultShaders = """
                          vertex float4 basic_vertex(                           // 1
                            const device packed_float4* vertex_array [[ buffer(0) ]], // 2
                            unsigned int vid [[ vertex_id ]]) {                 // 3
                            return vertex_array[vid];              // 4
                          }

                          fragment float4 basic_fragment() { // 1
                            return float4(1.0, 0, 0, 1.0);              // 2
                          }
                          """

class MetalPipeline : Pipeline {
    let pipelineState: MTLRenderPipelineState

    init(_ device: MTLDevice, _ descriptor: PipelineDescriptor) {
        guard let shaderLibrary = try? device.makeLibrary(source: defaultShaders, options: .none)  else {
            fatalError("Unable to create MTLLibrary")
        }

        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        if let vertexShader = descriptor.vertexShader {
            let vertexProgram = shaderLibrary.makeFunction(name: vertexShader)
            pipelineStateDescriptor.vertexFunction = vertexProgram
        }
        if let fragmentShader = descriptor.fragmentShader {
            let fragmentProgram = shaderLibrary.makeFunction(name: fragmentShader)
            pipelineStateDescriptor.fragmentFunction = fragmentProgram
        }

        pipelineStateDescriptor.colorAttachments[0].pixelFormat = descriptor.colorAttachments[0].pixelFormat.toMetal()

        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
}

#endif