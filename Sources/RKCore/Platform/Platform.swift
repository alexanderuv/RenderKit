//
// Created by alexander on 6/14/2021.
//

import Foundation

public protocol Platform {
    init()
    func createWindow(_ configuration: WindowConfiguration) throws -> Window
    func getHighResTime() -> Int
}