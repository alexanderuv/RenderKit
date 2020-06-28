//
// Created by Alexander Ubillus on 4/9/20.
//

import Foundation

public final class RenderKitApplication {

    private var window: Window
    private let platform: Platform

    init(window: Window, platform: Platform) {
        self.window = window
        self.platform = platform
    }

    public class func run(_ delegate: RenderApplicationDelegate, _ configuration: EngineConfiguration) throws {
        let backend = configuration.backend
        let platform = try createPlatform(forBackend: backend)
        let window = try platform.createWindow(configuration.window)
        let backendImpl = backend.createBackend(forPlatform: platform, configuration: configuration)

        delegate.initialize(backendImpl, window)

        window.show()
        window.runEventLoop() {
            delegate.render()
        }
    }
}

public protocol RenderApplicationDelegate {
    func initialize(_ backend: BackendProtocol, _ window: Window?)
    func render()
    func finalize()
}
