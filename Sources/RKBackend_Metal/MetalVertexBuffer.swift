//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation
import MetalKit
import RKCore

class MetalVertexBuffer: VertexBuffer{

    let hwBuffer: MTLBuffer

    init?(_ device: MTLDevice, _ layout: BufferLayout, _ count: Int) {

        let lengthInBytes = layout.stride * count
        let newBuffer = device.makeBuffer(length: lengthInBytes, options: .storageModeManaged)
        guard newBuffer != nil else {
            return nil
        }

        self.hwBuffer = newBuffer!
    }

    func updateBuffer<T>(contents: [T]) {
        let mem = hwBuffer.contents().bindMemory(to: T.self, capacity: contents.count)
        mem.assign(from: contents, count: contents.count)

        let totalLength = MemoryLayout<T>.stride * contents.count
        hwBuffer.didModifyRange(0..<totalLength)
    }

    func unwrap() -> Any? {
        hwBuffer
    }
}
