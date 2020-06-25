//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation
import MetalKit
import RenderKitCore

class MetalIndexBuffer: IndexBuffer {
    let hwBuffer: MTLBuffer

    init(_ hwBuffer: MTLBuffer) {
        self.hwBuffer = hwBuffer
    }

    func updateBuffer(contents: [UInt16]) {
        let mem = hwBuffer.contents().bindMemory(to: UInt16.self, capacity: contents.count)
        mem.assign(from: contents, count: contents.count)
    }
}
