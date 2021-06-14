//
// Created by Alexander Ubillus on 6/27/20.
//

import Foundation

public protocol BackendProtocol {
    func createDevice() throws -> Device
}

public enum Backend {
    case platformDefault
    case metal
    case directX12
    case vulkan
}

