//
// Created by Alexander Ubillus on 3/29/20.
//
#if os(macOS) || os(iOS)

import Foundation
import MetalKit
import RKCore

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

#endif