//
// Created by Alexander Ubillus on 3/29/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

class MetalSwapChain: SwapChain {

    // each swapchain will have its own id, this counter calculates the next one
    static let counter = AtomicInteger(value: 0)

    let metalLayer: CAMetalLayer
    let id: Int

    init(_ device: MetalDevice, _ size: NSSize) {
        id = MetalSwapChain.counter.incrementAndGet()

        metalLayer = MetalSwapChain.createMetalLayer(device)
        metalLayer.drawableSize = size
    }

    init(_ device: MetalDevice, _ window: CocoaWindow) {
        id = MetalSwapChain.counter.incrementAndGet()

        metalLayer = MetalSwapChain.createMetalLayer(device)
        let view = window.viewController.view

        metalLayer.drawableSize = view.convertToBacking(view.bounds.size)
        metalLayer.bounds = view.bounds

        view.wantsLayer = true
        view.layer = metalLayer
    }

    private static func createMetalLayer(_ device: MetalDevice) -> CAMetalLayer {
        let metalLayer = CAMetalLayer()
        metalLayer.device = device.metalDevice
        metalLayer.isOpaque = true

        return metalLayer
    }
}

#endif
