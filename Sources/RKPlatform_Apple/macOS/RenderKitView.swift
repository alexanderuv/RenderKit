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

    static let keysToCommon: [CGKeyCode: KeyCode] = macToRkMap()
    static let commonToKeys: [KeyCode: CGKeyCode] = keysToCommon.invert()

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
                let viewHandle = unsafeBitCast(userData, to: RenderKitView.self)
                viewHandle.signalRender()
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
        }
    }

    func signalRender() {
//        // Must synchronize if rendering on background thread to ensure resize operations from the
//        // main thread are complete before rendering which depends on the size occurs.
//        @synchronized(_metalLayer)
//        {
//            [_delegate renderToMetalLayer:_metalLayer];
//        }

        DispatchQueue(label: "render-thread").sync {
            renderKitHandle?.raiseRenderEvent(RenderEvent())
        }
    }

    func stopRender() {
        if let link = displayLink {
            // Stop the display link BEFORE releasing anything in the view otherwise the display link
            // thread may call into the view and crash when it encounters something that no longer exists
            CVDisplayLinkStop(link)
        }
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

//        renderKitHandle?.raiseWindowEvent(.close)
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

    override func keyDown(with event: NSEvent) {
        let translatedKeyCode = RenderKitView.keysToCommon[event.keyCode]!
        let modifierFlags = buildModifierFlags(event: event)

        let event = KeyboardEvent(keyCode: translatedKeyCode, flags: modifierFlags, type: .pressed)
        self.renderKitHandle?.raiseKeyboardEvent(event)
    }

    override func keyUp(with event: NSEvent) {
        let translatedKeyCode = RenderKitView.keysToCommon[event.keyCode]!
        let modifierFlags = buildModifierFlags(event: event)

        let event = KeyboardEvent(keyCode: translatedKeyCode, flags: modifierFlags, type: .released)
        self.renderKitHandle?.raiseKeyboardEvent(event)
    }

    override func mouseDown(with event: NSEvent) {
        let translatedEvent = MouseEvent(x: event.absoluteX, y: event.absoluteY, type: .buttonPressed, button: .left)
        self.renderKitHandle?.raiseMouseEvent(translatedEvent)
    }

    private func buildModifierFlags(event: NSEvent) -> ModifierFlags {
        var modifierFlags = ModifierFlags(rawValue: 0)
        if event.modifierFlags.contains(.capsLock) {
            modifierFlags = modifierFlags.union(.capsLock)
        }
        if event.modifierFlags.contains(.shift) {
            modifierFlags = modifierFlags.union(.shift)
        }
        if event.modifierFlags.contains(.control) {
            modifierFlags = modifierFlags.union(.control)
        }
        if event.modifierFlags.contains(.option) {
            modifierFlags = modifierFlags.union(.alt)
        }
        if event.modifierFlags.contains(.function) {
            modifierFlags = modifierFlags.union(.function)
        }
        return modifierFlags
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

    override func viewWillDisappear() {
        super.viewWillDisappear()
        (view as? RenderKitView)?.stopRender()
    }
}

fileprivate func macToRkMap() -> [UInt16: KeyCode] {
    [
        // numbers
        0x1d: .key0, 0x12: .key1, 0x13: .key2, 0x14: .key3, 0x15: .key4,
        0x17: .key5, 0x16: .key6, 0x1a: .key7, 0x1c: .key8, 0x19: .key9,

        // letters
        0x00: .keyA, 0x0B: .keyB, 0x08: .keyC, 0x02: .keyD, 0x0E: .keyE,
        0x03: .keyF, 0x05: .keyG, 0x04: .keyH, 0x22: .keyI, 0x26: .keyJ,
        0x28: .keyK, 0x25: .keyL, 0x2E: .keyM, 0x2D: .keyN, 0x1F: .keyO,
        0x23: .keyP, 0x0C: .keyQ, 0x0F: .keyR, 0x01: .keyS, 0x11: .keyT,
        0x20: .keyU, 0x09: .keyV, 0x0D: .keyW, 0x07: .keyX, 0x10: .keyY,
        0x06: .keyZ,

        // symbols
        0x27: .keyApostrophe,
        0x2A: .keyBackslash,
        0x2B: .keyComma,
        0x18: .keyEqual,
        0x32: .keyGraveAccent,
        0x21: .keyLeftBracket,
        0x1B: .keyMinus,
        0x2F: .keyPeriod,
        0x1E: .keyRightBracket,
        0x29: .keySemicolon,
        0x2C: .keySlash,

        // special keys
        0x33: .keyBackspace,
        0x39: .keyCapsLock,
        0x75: .keyDelete,
        0x7D: .keyDown,
        0x77: .keyEnd,
        0x24: .keyEnter,
        0x35: .keyEscape,

        // function keys
        0x7A: .keyF1, 0x78: .keyF2, 0x63: .keyF3, 0x76: .keyF4, 0x60: .keyF5,
        0x61: .keyF6, 0x62: .keyF7, 0x64: .keyF8, 0x65: .keyF9, 0x6D: .keyF10,
        0x67: .keyF11, 0x6F: .keyF12, 0x69: .keyF13, 0x6B: .keyF14, 0x71: .keyF15,
        0x6A: .keyF16, 0x40: .keyF17, 0x4F: .keyF18, 0x50: .keyF19, 0x5A: .keyF20,

        // more special keys
        0x73: .keyHome,
        0x72: .keyInsert,
        0x7B: .keyLeft,
        0x3A: .keyLeftAlt,
        0x3B: .keyLeftControl,
        0x38: .keyLeftShift,
        0x37: .keyLeftSuper,
        0x6E: .keyMenu,
        0x47: .keyNumLock,
        0x79: .keyPageDown,
        0x74: .keyPageUp,
        0x7C: .keyRight,
        0x3D: .keyRightAlt,
        0x3E: .keyRightControl,
        0x3C: .keyRightShift,
        0x36: .keyRightSuper,
        0x31: .keySpace,
        0x30: .keyTab,
        0x7E: .keyUp,

        // numpad keys
        0x52: .keyNumPad0,
        0x53: .keyNumPad1,
        0x54: .keyNumPad2,
        0x55: .keyNumPad3,
        0x56: .keyNumPad4,
        0x57: .keyNumPad5,
        0x58: .keyNumPad6,
        0x59: .keyNumPad7,
        0x5B: .keyNumPad8,
        0x5C: .keyNumPad9,
        0x45: .keyNumPadAdd,
        0x41: .keyNumPadDecimal,
        0x4B: .keyNumPadDivide,
        0x4C: .keyNumPadEnter,
        0x51: .keyNumPadEqual,
        0x43: .keyNumPadMultiply,
        0x4E: .keyNumPadSubtract
    ]
}
