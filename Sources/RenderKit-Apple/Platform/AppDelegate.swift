//
// Created by Alexander Ubillus on 4/10/20.
//

import Foundation
import Cocoa

class RenderKitAppDelegate: NSResponder, NSApplicationDelegate {
    static let shared = RenderKitAppDelegate()
    static var appInitialized = false

    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        if Bundle.main.path(forResource: "MainMenu", ofType: "nib") != nil {
            Bundle.main.loadNibNamed("MainMenu", owner: NSApp, topLevelObjects: nil)
        }
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ app: NSApplication) -> Bool {
        true
    }
}