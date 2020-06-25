//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

class PlatformVulkan: Platform {
    func createDevice() throws -> Device {
        fatalError("Not implemented")
    }

    func postProcessWindow(_ window: Window) {

    }

    func getDefaultSwapChain() -> SwapChain {
        NoopSwapChain()
    }

}
