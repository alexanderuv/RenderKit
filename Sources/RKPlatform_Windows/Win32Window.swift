
import SwiftWin32
import RKCore

class Win32Window: RKCore.Window {
    required init(_ configuration: WindowConfiguration) {

    }

    var keyboardEventHandler: ((KeyboardEvent) -> ())? = { _ in
    }
    var mouseEventHandler: ((MouseEvent) -> ())? = { _ in
    }
    var renderEventHandler: ((RenderEvent) -> ())? = { _ in
    }
    var windowEventHandler: ((WindowEvent) -> ())? = { _ in
    }

    func show() {
    }

    func showAndLoopUntilExit() {
    }

    func getNativeWindow() -> Any {
        fatalError("getNativeWindow() has not been implemented")
    }

    func pollEvents() {
    }
}