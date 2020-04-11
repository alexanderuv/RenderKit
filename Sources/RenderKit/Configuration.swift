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

    public init(title: String, width: Int, height: Int) {
        self.title = title
        self.width = width
        self.height = height
    }
}

public struct EngineConfiguration {
    public var window: WindowConfiguration
    public var backend: Backend

    public init(window: WindowConfiguration?, backend: Backend) {
        self.window = window ?? WindowConfiguration(title: "app", width: 800, height: 600)
        self.backend = backend
    }
}