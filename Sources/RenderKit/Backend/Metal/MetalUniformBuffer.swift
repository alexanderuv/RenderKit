//
// Created by Alexander Ubillus on 7/11/20.
//

#if os(macOS) || os(iOS)

import Foundation
import MetalKit

class MetalUniformBuffer: UniformBuffer {

    private let buffer: MTLBuffer

    init(_ buffer: MTLBuffer) {
        self.buffer = buffer
    }

    func updateContents<T>(_ content: T) {
        let memory = self.buffer.contents().bindMemory(to: T.self, capacity: 1)
        var copyOfContent = content
        memory.assign(from: &copyOfContent, count: 1)

        let stride = MemoryLayout<T>.stride
        self.buffer.didModifyRange(0..<stride)
    }
    
    func unwrap() -> Any? {
        buffer
    }
}

#endif
