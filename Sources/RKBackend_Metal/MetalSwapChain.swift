//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation
import MetalKit
import RKCore
import RKPlatform_Apple

class MetalSwapChain: SwapChain {

    // each swapchain will have its own id, this counter calculates the next one
    static let counter = AtomicInteger(value: 0)

    let metalLayer: CAMetalLayer
    let id = MetalSwapChain.counter.incrementAndGet()

    init(_ device: MetalDevice, size: NSSize) {
        metalLayer = MetalSwapChain.createMetalLayer(device)
        metalLayer.drawableSize = size
    }
    
    init(_ device: MetalDevice, handle: Any) {
        metalLayer = handle as! CAMetalLayer
    }

    init(_ device: MetalDevice, window: MetalEnabled) {
        metalLayer = MetalSwapChain.createMetalLayer(device)
        window.enableMetal(metalLayer)
    }

    private static func createMetalLayer(_ device: MetalDevice) -> CAMetalLayer {
        let metalLayer = CAMetalLayer()
        metalLayer.device = device.metalDevice
        metalLayer.isOpaque = true

        return metalLayer
    }
}
