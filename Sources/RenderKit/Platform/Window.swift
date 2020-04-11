//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Window {
    init(_ configuration: WindowConfiguration)

    func show()
    func hide()
    func shouldClose() -> Bool
    func pollEvents()
    func focusWindow()
    func getNativeWindow() -> Any

    func runEventLoop(_ delegate: @escaping () -> Void)
}

func createNativeWindow(_ configuration: WindowConfiguration) throws -> Window {
    #if os(macOS)
    return CocoaWindow(configuration)
    #else
    throw RenderKitError.errorCreatingNativeWindow
    #endif
}