//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Window {
    init(_ configuration: WindowConfiguration)

    var keyboardEventHandler: ((KeyboardEvent) -> ())? { get set }
    var mouseEventHandler: ((MouseEvent) -> ())? { get set }
    var renderEventHandler: ((RenderEvent) -> ())? { get set }
    var windowEventHandler: ((WindowEvent) -> ())? { get set }

    func show()
    func showAndLoopUntilExit()
    func getNativeWindow() -> Any

    func pollEvents()
}
