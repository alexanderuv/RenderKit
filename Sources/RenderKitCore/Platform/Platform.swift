//
// Created by Alexander Ubillus on 6/24/20.
//

import Foundation

public protocol Platform {
    func createDevice() throws -> Device
}