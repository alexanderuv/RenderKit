//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
#if os(macOS)
import AppKit
import CoreVideo

typealias PlatWindow = NSWindow
typealias PlatApplication = NSApplication
#elseif os(iOS)
import UIKit

typealias PlatWindow = UIWindow
typealias PlatApplication = UIApplication
#endif

import MetalKit

public class CocoaWindow: Window {

    internal let nsWindow: RenderKitWindow
    internal let nsWindowDelegate: RenderKitWindowDelegate
    let viewController: RenderKitViewController

    // event handlers
    public var keyboardEventHandler: ((KeyboardEvent) -> ())? = nil
    public var mouseEventHandler: ((MouseEvent) -> ())? = nil
    public var renderEventHandler: ((RenderEvent) -> ())? = nil
    public var windowEventHandler: ((WindowEvent) -> ())? = nil

    public required init(_ configuration: WindowConfiguration) {
        nsWindowDelegate = RenderKitWindowDelegate()

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

        nsWindowDelegate.window = self
        nsWindow.title = configuration.title
        nsWindow.delegate = nsWindowDelegate
        nsWindow.contentView = viewController.view
        nsWindow.makeFirstResponder(nsWindow.contentView)
        nsWindow.acceptsMouseMovedEvents = true
        nsWindow.isRestorable = false
    }

    public func show() {
        nsWindow.orderFront(nil)

        NSApp.activate(ignoringOtherApps: true)
        nsWindow.makeKeyAndOrderFront(nil)
    }
    
    public func runMessageLoop() {
        NSApp.run()
    }
    
    public func showAndLoopUntilExit() {
        show()
        runMessageLoop()
    }

    public func getNativeWindow() -> Any {
        nsWindow
    }

    func tearDown() {
        // do appropriate tear down
    }

    public func pollEvents() {
        autoreleasepool {
            if !MacOSPlatform.finishedLaunching {
                NSApp.run()
            }

            while true {
                guard let event = NSApp.nextEvent(
                        matching: .any,
                        until: Date.distantPast,
                        inMode: .default,
                        dequeue: true) else {
                    break
                }

                NSApp.sendEvent(event)
            }
        }
    }

    func raiseKeyboardEvent(_ event: KeyboardEvent) {
        self.keyboardEventHandler?(event)
    }

    func raiseMouseEvent(_ event: MouseEvent) {
        self.mouseEventHandler?(event)
    }

    func raiseRenderEvent(_ event: RenderEvent) {
        self.renderEventHandler?(event)
    }

    func raiseWindowEvent(_ event: WindowEvent) {
        self.windowEventHandler?(event)
    }
}

class RenderKitWindowDelegate: NSObject, NSWindowDelegate {
    var window: CocoaWindow!

    func windowWillClose(_ notification: Notification) {
        window.raiseWindowEvent(WindowEvent(type: .close))
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
