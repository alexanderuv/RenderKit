//
// Created by Alexander Ubillus on 3/27/20.
//

import Foundation
import RenderKitCore
import RenderKitApple

extension Window {

}

func createNativeWindow(_ configuration: WindowConfiguration) throws -> Window {
    #if os(macOS)
    return CocoaWindow(configuration)
    #else
    throw RenderKitError.errorCreatingNativeWindow
    #endif
}