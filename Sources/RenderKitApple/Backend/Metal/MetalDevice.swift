//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation
import MetalKit
import RenderKitCore

class MetalDevice: Device {
    let metalDevice: MTLDevice

    init(_ device: MTLDevice) {
        self.metalDevice = device
    }

    func createCommandQueue() -> CommandQueue {
        guard let commandQueue = metalDevice.makeCommandQueue() else {
            fatalError("Error creating command queue")
        }
        return MetalCommandQueue(commandQueue)
    }

    func createSwapChain(fromWindow window: Window) -> SwapChain {
        guard let window = window as? CocoaWindow else {
            fatalError("Invalid native window passed to create metal swapchain")
        }

        return MetalSwapChain(self, window)
    }

    func createSwapChain(offscreenSize size: NSSize) -> SwapChain {
        MetalSwapChain(self, size)
    }

    func createPipeline(descriptor: PipelineDescriptor) -> Pipeline {
        MetalPipeline(self.metalDevice, descriptor)
    }

    func createVertexBuffer<T: VertexBuffer<V>, V>(withVertexType vertexType: V.Type, count: Int) -> Result<T, RenderKitError> {
        if let newBuffer = MetalVertexBuffer<V>(self.metalDevice, count) {
            return .success(newBuffer as! T)
        }

        return .failure(RenderKitError.errorCreatingHardwareBuffer)
    }

    func createIndexBuffer(withCount count: Int) -> Result<IndexBuffer, RenderKitError> {
        let totalLength = count * MemoryLayout<UInt16>.stride
        if let newBuffer = metalDevice.makeBuffer(length: totalLength, options: [.storageModeShared]) {
            return .success(MetalIndexBuffer(newBuffer))
        }

        return .failure(RenderKitError.errorCreatingHardwareBuffer)
    }
}
