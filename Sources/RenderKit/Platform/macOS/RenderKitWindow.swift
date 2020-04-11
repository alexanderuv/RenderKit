//
// Created by Alexander Ubillus on 4/10/20.
//

import Foundation
import AppKit

class RenderKitWindow: PlatWindow {
    override var canBecomeKey: Bool {
        true
    }
    override var canBecomeMain: Bool {
        true
    }
}
