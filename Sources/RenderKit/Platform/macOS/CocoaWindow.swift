//
// Created by Alexander Ubillus on 3/27/20.
//

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

public class CocoaWindow: Window {
    var clearColor: Color = .red

    internal let nsWindow: RenderKitWindow
    let viewController: RenderKitViewController
    var renderDelegate: (() -> Void)?

    public required init(_ configuration: WindowConfiguration) {
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

    public func show() {
        nsWindow.orderFront(nil)

        NSApp.activate(ignoringOtherApps: true)
        nsWindow.makeKeyAndOrderFront(nil)
    }

    public func getNativeWindow() -> Any {
        nsWindow
    }

    func render() {
        renderDelegate?()
    }

    public func runEventLoop(_ delegate: @escaping () -> Void) {
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