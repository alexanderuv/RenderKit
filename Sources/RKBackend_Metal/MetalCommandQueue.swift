//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation
import MetalKit
import RKCore

class MetalCommandQueue: CommandQueue {
    let commandQueue: MTLCommandQueue

    init(_ commandQueue: MTLCommandQueue) {
        self.commandQueue = commandQueue
    }

    func createCommandBuffer() -> CommandBuffer {
        guard let nativeCommandBuffer = commandQueue.makeCommandBuffer() else {
            fatalError("Unable to create command buffer")
        }

        return MetalCommandBuffer(nativeBuffer: nativeCommandBuffer)
    }
}
