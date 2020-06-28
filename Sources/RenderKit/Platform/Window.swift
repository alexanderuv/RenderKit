//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation

public protocol Window {
    init(_ configuration: WindowConfiguration)

    func show()
    func getNativeWindow() -> Any

    func runEventLoop(_ delegate: @escaping () -> Void)
}