//
// Created by Alexander Ubillus on 3/29/20.
//

#if os(macOS) || os(iOS)
import Foundation
import MetalKit

class MetalIndexBuffer: IndexBuffer {
    let hwBuffer: MTLBuffer

    init(_ hwBuffer: MTLBuffer) {
        self.hwBuffer = hwBuffer
    }

    func updateBuffer(contents: [UInt16]) {
        hwBuffer.contents().storeBytes(of: contents, as: [UInt16].self)
    }
}

#endif