//
// Created by Alexander Ubillus on 7/2/20.
//

import Foundation
import RenderKit
import Cocoa

typealias Vertex = SIMD4<Float>

struct VertexData {
    let position: SIMD3<Float> // NOTE: Swift will treat this as a float4 due to alignment logic in the compiler
    let color: SIMD4<Float>
    
    init(position: SIMD3<Float>, color: SIMD4<Float>) {
        self.position = position
        self.color = color
    }
}

class SampleApplication {
    
    private var isRunning = true
    
    private var device: Device!
    private var commandQueue: CommandQueue!
    private var vertexBuffer: VertexBuffer!
    private var indexBuffer: IndexBuffer!
    private var swapChain: SwapChain!
    private var pipeline: Pipeline!
    
    public func run(_ configuration: WindowConfiguration) throws {
        let platform = try createPlatform()
        var window = try platform.createWindow(configuration)
        let backendImpl = Backend.platformDefault.createBackend(forPlatform: platform)
                
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
    
    private func initializeRenderer(_ backend: BackendProtocol, _ window: Window) {
        device = try! backend.createDevice()
        
        let vertexLayout = BufferLayout(attributes:
            [
                BufferLayoutAttribute(dataType: .float4, name: "position"), // using float4 as that's the physical layout for the struct
                BufferLayoutAttribute(dataType: .float4, name: "color")
        ], stride: MemoryLayout<VertexData>.stride)
        
        guard let vertexBuffer = try? device.createVertexBuffer(withLayout: vertexLayout, count: 3).get() else {
            fatalError("Error creating a vertexBuffer")
        }
        
        let vertices: [VertexData] = [
            VertexData(position: [0.0, 1.0, 0.0], color: [0.8,1,0.5,1]),
            VertexData(position: [-1.0, -1.0, 0.0], color: [0.5,0.8,1,1]),
            VertexData(position: [1.0, -1.0, 0.0], color: [1,0.5,0.8,1])
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
        struct VertexIn {
            float3 position [[attribute(0)]];
            float4 color [[attribute(1)]];
        };

        struct VertexOut {
            float4 position [[position]];
            float4 color;
        };

        vertex VertexOut vertexMain(VertexIn vertex_in [[stage_in]])
        {
            VertexOut vertex_out;
            vertex_out.position = float4(vertex_in.position, 1.0);
            vertex_out.color = vertex_in.color;
            return vertex_out;
        }

        fragment float4 fragmentMain(VertexOut vertex_in [[stage_in]]) {
            return vertex_in.color;
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
