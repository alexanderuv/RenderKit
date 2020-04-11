//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RenderKit

let configuration = EngineConfiguration(
        window: WindowConfiguration(
                title: "My demo app",
                width: 800,
                height: 600
        ),
        backend: .metal)

let appRenderer = MyRenderer()
try RenderKitApplication.run(appRenderer, configuration)

