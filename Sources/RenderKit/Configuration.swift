//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import Logging

public struct WindowConfiguration {
    public var title: String
    public var width: Int
    public var height: Int
    public var decorated = true
    public var resizable = true
    public var floating = false
    public var maximized = false

    public init(title: String) {
        self.init(title: title, width: 800, height: 600)
    }

    public init(fullscreenAppName title: String) {
        self.init(title: title, width: -1, height: -1)
    }

    public init(title: String, width: Int, height: Int) {
        self.title = title
        self.width = width
        self.height = height
    }
}