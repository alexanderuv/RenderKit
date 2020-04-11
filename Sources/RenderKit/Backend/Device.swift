//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation

public protocol Device {
    func createVertexBuffer<T: VertexBuffer<V>, V>(withCount count: Int, vertexType: V.Type) -> Result<T, RenderKitError>
    func createIndexBuffer(withCount: Int) -> Result<IndexBuffer, RenderKitError>
    func createPipeline(descriptor: PipelineDescriptor) -> Pipeline
    func createCommandQueue() -> CommandQueue
    func createSwapChain(fromWindow window: Window) -> SwapChain
    func createSwapChain(offscreenSize size: NSSize) -> SwapChain
}
