//
// Created by Alexander Ubillus on 6/27/20.
//

import Foundation
import RKCore

public class LinuxPlatform: Platform {
    public required init() {

    }

    public func createWindow(_ configuration: WindowConfiguration) throws -> Window {
        fatalError("createWindow(_:) has not been implemented")
    }

    public func getHighResTime() -> Int {
        fatalError("getHighResTime() has not been implemented")
    }
}
