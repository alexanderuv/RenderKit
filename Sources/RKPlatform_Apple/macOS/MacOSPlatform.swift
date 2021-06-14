//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import MetalKit
import Cocoa
import Carbon

public class MacOSPlatform: Platform {
    
    let helper = MacOSHelper()
    static var finishedLaunching = false
    var appDelegate: RKApplicationDelegate!
    
    var keyUpMonitor: Any? = nil
    var eventSource: CGEventSource? = nil
    
    private var textInputSourceInfo: TISInfo? = nil
    
    public required init() {
        
        autoreleasepool {
            Thread.detachNewThread() {
            }
            
            if NSApp != nil {
                MacOSPlatform.finishedLaunching = true
            }
            
            let _ = NSApplication.shared
            
            self.appDelegate = RKApplicationDelegate(platform: self)
            NSApp.delegate = self.appDelegate
            
            let block: (NSEvent) -> NSEvent = { event in
                if event.modifierFlags.rawValue & NSEvent.ModifierFlags.command.rawValue != 0 {
                    NSApp.keyWindow?.sendEvent(event)
                }
                
                return event
            }
            
            keyUpMonitor = NSEvent.addLocalMonitorForEvents(
                matching: .keyUp,
                handler: block)
            
            // Press and Hold prevents some keys from emitting repeated characters
            let defaults = [
                "ApplePressAndHoldEnabled": NSNumber(value: false)
            ]
            UserDefaults.standard.register(defaults: defaults)
            
            NotificationCenter.default.addObserver(
                self.helper,
                selector: #selector(MacOSHelper.selectedKeyboardInputSourceChanged(_:)),
                name: NSTextInputContext.keyboardSelectionDidChangeNotification,
                object: nil)
            
            self.eventSource = CGEventSource(stateID: .hidSystemState)
            self.eventSource?.localEventsSuppressionInterval = 0.0
            self.textInputSourceInfo = initializeTIS()
        }
    }
    
    private func initializeTIS() -> TISInfo {
        var tisInfo = TISInfo()
        let inputSource = TISCopyCurrentKeyboardLayoutInputSource()
        guard let property = TISGetInputSourceProperty(inputSource?.takeUnretainedValue(),
                                                       kTISPropertyUnicodeKeyLayoutData) else {
            fatalError("Cocoa: Unable to get keyboard layout data")
        }
        let layoutData = Unmanaged<CFData>.fromOpaque(property).takeUnretainedValue() as Data
        tisInfo.unicodeData = layoutData
        
        return tisInfo
    }
    
    public func createWindow(_ configuration: WindowConfiguration) throws -> Window {
        CocoaWindow(configuration)
    }
    
    public func getHighResTime() -> Int {
        Int((mach_continuous_time() << 32) >> 32)
    }
    
    func postEmptyEvent() {
        autoreleasepool {
            
            if !MacOSPlatform.finishedLaunching {
                NSApp.run()
            }
            
            let event = NSEvent.otherEvent(
                with: .applicationDefined,
                location: NSPoint(x: 0, y: 0),
                modifierFlags: [],
                timestamp: 0,
                windowNumber: 0,
                context: nil,
                subtype: 0,
                data1: 0,
                data2: 0)
            
            if let event = event {
                NSApp.postEvent(event, atStart: true)
            }
            
            // autoreleasepool
        }
    }
}

class RKApplicationDelegate: NSObject, NSApplicationDelegate {
    
    unowned let platform: MacOSPlatform
    
    init(platform: MacOSPlatform) {
        self.platform = platform
        super.init()
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        .terminateNow
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
    
    func applicationDidChangeScreenParameters(_ notification: Notification) {
        //        var window: _GLFWwindow?
        //
        //        window = glfw.windowListHead
        //        while window {
        //            if window?.context.client != GLFW_NO_API {
        //                window?.context.nsgl.object.update()
        //            }
        //            window = window?.next
        //        }
        //
        //        glfwPollMonitorsNS()
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        // In case we are unbundled, make us a proper UI application
        NSApp.setActivationPolicy(.regular)
        
        // menubar can be created here...
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        MacOSPlatform.finishedLaunching = true
        self.platform.postEmptyEvent()
    }
}

class MacOSHelper: NSObject {
    
    @objc
    func selectedKeyboardInputSourceChanged(_ object: NSObject?) {
        //        updateUnicodeDataNS()
    }
    
    func doNothing() {
        //
    }
}

fileprivate struct TISInfo {
    var unicodeData: Data? = nil
}

extension MacOSPlatform {
    
}

