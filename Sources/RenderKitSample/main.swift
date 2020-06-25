//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RenderKit
import RenderKitCore
import Cocoa

let configuration = EngineConfiguration(
        window: WindowConfiguration(
                title: "My demo app",
                width: 800,
                height: 600
        ),
        backend: .metal)

let appRenderer = SampleRenderer()
try RenderKitApplication.run(appRenderer, configuration)

// #=====

//let delegate = TestAppDelegate()
//let app = NSApplication.shared
//app.delegate = delegate
//app.setActivationPolicy(.regular)
//app.run()
