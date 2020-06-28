//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation

class VulkanVertexBuffer<T> : VertexBuffer<T> {
    override func unwrap() -> AnyObject? {
        fatalError("Not implemented")
    }

    override func updateBuffer(contents: [T]) {
        fatalError("Not implemented")
    }

}
