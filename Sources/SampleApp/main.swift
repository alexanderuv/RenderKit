//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RenderKit

let configuration = WindowConfiguration(
        title: "RenderKit Demo",
        width: 800,
        height: 600
)

let app = SampleApplication()
try app.run(configuration)
