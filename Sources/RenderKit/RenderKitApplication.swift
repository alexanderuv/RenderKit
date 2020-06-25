//
// Created by Alexander Ubillus on 4/9/20.
//

import Foundation
import RenderKitCore

public final class RenderKitApplication {

    private var window: Window
    private let platform: Platform

    init(window: Window, platform: Platform) {
        self.window = window
        self.platform = platform
    }

    public class func run(_ delegate: RenderApplicationDelegate, _ configuration: EngineConfiguration) throws {
        let backend = configuration.backend
        let window = try createNativeWindow(configuration.window)
        let platform = try createPlatform(forBackend: backend)

        delegate.initialize(platform, window)

        window.show()
        window.focusWindow()

        window.runEventLoop() {
            delegate.render()
        }
    }
}

public protocol RenderApplicationDelegate {
    func initialize(_ platform: Platform, _ window: Window?)
    func render()
    func finalize()
}
