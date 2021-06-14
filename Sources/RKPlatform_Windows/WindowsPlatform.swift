//
// Created by alexander on 6/14/2021.
//

import Foundation
import RKCore

public class WindowsPlatform: Platform {

    public required init() {

    }

    public func createWindow(_ configuration: WindowConfiguration) throws -> Window {
        Win32Window(configuration)
    }

    public func getHighResTime() -> Int {
        fatalError("getHighResTime() has not been implemented")
    }
}
