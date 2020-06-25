//
// Created by Alexander Ubillus on 6/24/20.
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