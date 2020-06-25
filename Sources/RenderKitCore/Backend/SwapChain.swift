//
// Created by Alexander Ubillus on 3/28/20.
//

import Foundation

public protocol SwapChain {
    var id: Int { get }
}

class NoopSwapChain: SwapChain {
    var id: Int = 0
}