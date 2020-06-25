//
// Created by Alexander Ubillus on 3/27/20.
//

#if os(macOS) || os(iOS)
import Foundation
#if os(macOS)
import AppKit
import CoreVideo

typealias PlatWindow = NSWindow
typealias PlatApplication = NSApplication
#else
import UIKit

typealias PlatWindow = UIWindow
typealias PlatApplication = UIApplication
#endif

import MetalKit

class CocoaWindow: Window {
    var clearColor: Color = .red

    internal let nsWindow: RenderKitWindow
    let viewController: RenderKitViewController
    var windowShouldClose = false
    var renderDelegate: (() -> Void)?

    required init(_ configuration: WindowConfiguration) {
        let app = PlatApplication.shared
        app.delegate = RenderKitAppDelegate.shared

        // create NSWindow
        let contentRect = NSMakeRect(0, 0, CGFloat(configuration.width), CGFloat(configuration.height));
        nsWindow = RenderKitWindow(
                contentRect: contentRect,
                styleMask: getStyleMask(configuration),
                backing: .buffered,
                defer: false
        )

        // create controller and its NSView
        viewController = RenderKitViewController()
        viewController.parentHandle = self

        nsWindow.center()
        if (configuration.resizable) {
            nsWindow.collectionBehavior = [.fullScreenPrimary, .managed]
        }

        if (configuration.floating) {
            nsWindow.level = .floating
        }

        if (configuration.maximized) {
            nsWindow.zoom(nil)
        }

        nsWindow.title = configuration.title
        nsWindow.contentView = viewController.view
        nsWindow.makeFirstResponder(nsWindow.contentView)
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.isRestorable = false
    }

    func show() {
        nsWindow.orderFront(nil)
    }

    func focusWindow() {
        NSApp.activate(ignoringOtherApps: true)
        nsWindow.makeKeyAndOrderFront(nil)
    }

    func hide() {
        nsWindow.orderBack(nil)
    }

    func shouldClose() -> Bool {
        windowShouldClose
    }

    func pollEvents() {
        while true {
            let event = NSApp.nextEvent(
                    matching: .any,
                    until: .distantPast,
                    inMode: .default,
                    dequeue: true)

            if event == nil {
                break
            }

            NSApp.sendEvent(event!)
        }
    }

    func getNativeWindow() -> Any {
        nsWindow
    }

    func render() {
        renderDelegate?()
    }

    func runEventLoop(_ delegate: @escaping () -> Void) {
        renderDelegate = delegate
        NSApp.run()
    }

    func tearDown() {

    }
}

func getStyleMask(_ configuration: WindowConfiguration) -> NSWindow.StyleMask {
    var styleMask: NSWindow.StyleMask = [.miniaturizable]
    if (!configuration.decorated) {
        styleMask.insert(.borderless)
    } else {
        styleMask.insert(.titled)
        styleMask.insert(.closable)

        if (configuration.resizable) {
            styleMask.insert(.resizable)
        }
    }

    return styleMask
}

#endif