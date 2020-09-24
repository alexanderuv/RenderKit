//
// Created by Alexander Ubillus on 7/2/20.
//

import Foundation
import RenderKit
import Cocoa

typealias Vertex = SIMD4<Float>

struct VertexData {
    let position: SIMD3<Float>
    let normal: SIMD3<Float>
    let uv: SIMD2<Float>
    
    init(position: SIMD3<Float>) {
        self.position = position
        self.normal = .zero
        self.uv = .zero
    }
}

struct UniformData {
    var modelMatrix: Matrix4x4 = .zero
    var viewMatrix: Matrix4x4 = .identity
    var projectionMatrix: Matrix4x4 = .identity
    var time: Float = 0
}

class SampleApplication {
    
    private var isRunning = true
    
    private var device: Device!
    private var commandQueue: CommandQueue!
    private var vertexBuffer: VertexBuffer!
    private var indexBuffer: IndexBuffer!
    private var swapChain: SwapChain!
    private var pipeline: Pipeline!
    
    private var uniforms = UniformData()
    
    public func run(_ configuration: WindowConfiguration) throws {
        let platform = try createPlatform()
        var window = try platform.createWindow(configuration)
        let backendImpl = Backend.platformDefault.createBackend(forPlatform: platform)
        
        uniforms.modelMatrix = Matrix4x4.identity.rotateZ(degrees: 0)
                
        initializeRenderer(backendImpl, window)
        
        window.show()
        
        window.renderEventHandler = render
        window.windowEventHandler = handleWindowEvent
        window.keyboardEventHandler = handleKeyboardEvent
        window.mouseEventHandler = handleMouseEvent
        
        while isRunning {
            window.pollEvents()
        }
    }
    
    func handleMouseEvent(_ event: MouseEvent) {
        print("received: \(event)")
    }
    
    func handleKeyboardEvent(_ event: KeyboardEvent) {
        print("received: \(event)")
    }
    
    public func handleWindowEvent(_ event: WindowEvent) {
        isRunning = false
    }
    
    private func render(_ event: RenderEvent) {
        let commandBuffer = commandQueue.createCommandBuffer()

        _ = commandBuffer.doRenderPass(on: self.swapChain) {
            
            commandBuffer.setPipeline(pipeline)
            
            // update the contents every frame
            uniforms.time += 0.1
            
            commandBuffer.setVertexBuffer(vertexBuffer, offset: 0)
            commandBuffer.setIndexBuffer(indexBuffer)
            commandBuffer.setUniforms(uniforms, slot: 1, stage: .all)
            commandBuffer.drawIndexed(primitive: .triangle, indexCount: 3, indexOffset: 0)
        }
    }
    
    private func initializeRenderer(_ backend: BackendProtocol, _ window: Window) {
        device = try! backend.createDevice()
        
        let vertexLayout = BufferLayout(attributes: [
                BufferLayoutAttribute(name: "position", format: .float3),
                BufferLayoutAttribute(name: "normal", format: .float3),
                BufferLayoutAttribute(name: "uv", format: .float2)
        ], stride: MemoryLayout<VertexData>.stride)
        
        guard let vertexBuffer = try? device.createVertexBuffer(withLayout: vertexLayout, count: 3).get() else {
            fatalError("Error creating a vertexBuffer")
        }
        
        let vertices: [VertexData] = [
            VertexData(position: [0.0, 1.0, 0.0]),
            VertexData(position: [-1.0, -1.0, 0.0]),
            VertexData(position: [1.0, -1.0, 0.0])
        ]
        
        vertexBuffer.updateBuffer(contents: vertices)
        
        guard let indexBuffer = try? device.createIndexBuffer(withCount: 3).get() else {
            fatalError("Error creating an indexBuffer")
        }
        
        indexBuffer.updateBuffer(contents: [0, 1, 2])
        
        self.vertexBuffer = vertexBuffer
        self.indexBuffer = indexBuffer
        
        commandQueue = device.createCommandQueue()
        swapChain = device.createSwapChain(fromWindow: window)
        
        let shaderContent =
        """
        #include <metal_stdlib>
        using namespace metal;

        struct VertexIn {
            float3 position [[attribute(0)]];
            float3 normal [[attribute(1)]];
            float2 uv [[attribute(2)]];
        };

        struct VertexOut {
            float4 position [[position]];
            float3 normal;
        };

        struct Uniforms {
            float4x4 model;
            float4x4 view;
            float4x4 projection;
            float time;
        };

        vertex VertexOut vertexMain(VertexIn vertex_in [[stage_in]],
                                    constant Uniforms& uniforms [[ buffer(1) ]])
        {
            VertexOut vertex_out;
            vertex_out.position = uniforms.projection * uniforms.view * uniforms.model * float4(vertex_in.position, 1.0);
            vertex_out.normal = vertex_in.normal;
            return vertex_out;
        }

        fragment float4 fragmentMain(VertexOut vertex_in [[stage_in]],
                                     constant Uniforms& uniforms [[ buffer(1) ]]) {
            auto x = sin(uniforms.time) + 0.5;
            return float4(x);
        }
        """
        
        let shader = Shader(
            content: shaderContent,
            vertexFunction: "vertexMain",
            fragmentFunction: "fragmentMain")
        
        var pipelineDesc = PipelineDescriptor(vertexLayout: vertexLayout, shader: shader)
        pipelineDesc.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipeline = device.createPipeline(descriptor: pipelineDesc)
    }
}
