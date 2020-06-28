//
// Created by Alexander Ubillus on 3/29/20.
//
#if os(macOS) || os(iOS)

import Foundation
import MetalKit

class MetalVertexBuffer<T> : VertexBuffer<T> {

    let hwBuffer: MTLBuffer

    init?(_ device: MTLDevice, _ count: Int) {
        let totalLength = MemoryLayout<T>.stride * count
        let newBuffer = device.makeBuffer(length: totalLength, options: .storageModeManaged)
        guard newBuffer != nil else {
            return nil
        }

        self.hwBuffer = newBuffer!
        super.init()

    }

    override func updateBuffer(contents: [T]) {
        let mem = hwBuffer.contents().bindMemory(to: T.self, capacity: contents.count)
        mem.assign(from: contents, count: contents.count)
        
        let totalLength = MemoryLayout<T>.stride * contents.count
        hwBuffer.didModifyRange(0..<totalLength)
    }

    override func unwrap() -> AnyObject {
        hwBuffer
    }
}

#endif