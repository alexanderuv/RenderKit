//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation

public protocol Device {
    func createVertexBuffer(withLayout layout: BufferLayout, count: Int) -> Result<VertexBuffer, RenderKitError>
    func createIndexBuffer(withCount: Int) -> Result<IndexBuffer, RenderKitError>
    func createPipeline(descriptor: PipelineDescriptor) -> Pipeline
    func createCommandQueue() -> CommandQueue
    func createSwapChain(fromWindow window: Window) -> SwapChain
    func createSwapChain(fromNativeHandle handle: Any) -> SwapChain
    func createSwapChain(offscreenSize size: NSSize) -> SwapChain
    
    func unwrap() -> Any?
}
