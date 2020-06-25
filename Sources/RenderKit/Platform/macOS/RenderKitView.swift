//
// Created by Alexander Ubillus on 4/10/20.
//

import Foundation
import AppKit

class RenderKitView: NSView, CALayerDelegate, NSWindowDelegate {

    var trackingArea: NSTrackingArea?
    var markedText = NSMutableAttributedString()
    var displayLink: CVDisplayLink? = nil
    weak var renderKitHandle: CocoaWindow?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        initCommon()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initCommon()
    }

    func initCommon() {
        self.layerContentsRedrawPolicy = .duringViewResize
        updateTrackingAreas()
        self.layer?.delegate = self
    }

    func setupCVDisplayLink(forScreen screen: NSScreen) {
        var res = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)

        guard kCVReturnSuccess == res else {
            print("Display Link created with error: {}", res)
            displayLink = nil
            return
        }

        func renderDelegate(_ displayLink: CVDisplayLink,
                            _ now: UnsafePointer<CVTimeStamp>,
                            _ outputTime: UnsafePointer<CVTimeStamp>,
                            _ flagsIn: CVOptionFlags,
                            _ flagsOut: UnsafeMutablePointer<CVOptionFlags>,
                            _ userData: UnsafeMutableRawPointer?) -> CVReturn {

            autoreleasepool {
                let handle = unsafeBitCast(userData, to: RenderKitView.self)
                handle.render()
            }

            return kCVReturnSuccess
        }

        if let link = displayLink {
            res = CVDisplayLinkSetOutputCallback(link, renderDelegate, Unmanaged.passUnretained(self).toOpaque())
            guard kCVReturnSuccess == res else {
                print("Display Link callback could not be set: {}", res)
                return
            }

            let viewDisplayID = window?.screen?.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! CGDirectDisplayID
            res = CVDisplayLinkSetCurrentCGDisplay(link, viewDisplayID)

            guard kCVReturnSuccess == res else {
                print("Display Link could not be linked: {}", res)
                return
            }

            CVDisplayLinkStart(link)

            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self,
                    selector: #selector(NSWindowDelegate.windowWillClose(_:)),
                    name: NSWindow.willCloseNotification, object: window)
        }
    }

    func render() {
//        // Must synchronize if rendering on background thread to ensure resize operations from the
//        // main thread are complete before rendering which depends on the size occurs.
//        @synchronized(_metalLayer)
//        {
//            [_delegate renderToMetalLayer:_metalLayer];
//        }
        renderKitHandle?.render()
    }

    func stopRender() {
        if let link = displayLink {
            // Stop the display link BEFORE releasing anything in the view otherwise the display link
            // thread may call into the view and crash when it encounters something that no longer
            // exists
            CVDisplayLinkStop(link)
        }

        renderKitHandle?.tearDown()
    }

    func resizeDrawable(scaleFactor: CGFloat) {
        var newSize = self.bounds.size;
        newSize.width *= scaleFactor
        newSize.height *= scaleFactor

//        let lockQueue = DispatchQueue(label: "metalLayer")
//        lockQueue.sync {
//            metalLayer.drawableSize = newSize
//
//            delegate.drawableResize(newSize)
//        }
    }

    func windowWillClose(_ notification: Notification) {
        // Stop the display link when the window is closing since there
        // is no point in drawing something that can't be seen
        if notification.object as AnyObject? === self.window {
            CVDisplayLinkStop(displayLink!)
        }
    }

    override var acceptsFirstResponder: Bool {
        true
    }

    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        true
    }

    override var wantsUpdateLayer: Bool {
        true
    }

    override func cursorUpdate(with event: NSEvent) {
        super.cursorUpdate(with: event)
    }

    override func viewDidMoveToWindow() {
        if let screen = self.window?.screen {
            self.setupCVDisplayLink(forScreen: screen)
            self.resizeDrawable(scaleFactor: screen.backingScaleFactor)
        }
    }

    override func viewDidChangeBackingProperties() {
        super.viewDidChangeBackingProperties()
        if let screen = self.window?.screen {
            self.resizeDrawable(scaleFactor: screen.backingScaleFactor)
        }
    }

    override func setFrameSize(_ newSize: NSSize) {
        super.setFrameSize(newSize)
        if let screen = self.window?.screen {
            self.resizeDrawable(scaleFactor: screen.backingScaleFactor)
        }
    }

    override func setBoundsSize(_ newSize: NSSize) {
        super.setBoundsSize(newSize)
        if let screen = self.window?.screen {
            self.resizeDrawable(scaleFactor: screen.backingScaleFactor)
        }
    }
}

class RenderKitViewController: NSViewController {
    #if os(iOS)
    var displayLink: CADisplayLink!
    #endif

    weak var parentHandle: CocoaWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        #if os(iOS)
//        displayLink = CADisplayLink(target: self, selector: #selector(render))
//        displayLink.preferredFramesPerSecond = 60
//        displayLink.add(to: RunLoop.current, forMode: .default)
        #endif
    }

    override func loadView() {
        let v = RenderKitView()
        v.renderKitHandle = self.parentHandle
        view = v
    }
}

