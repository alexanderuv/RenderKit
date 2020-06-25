//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation

public protocol CommandQueue {
    func createCommandBuffer() -> CommandBuffer
}
