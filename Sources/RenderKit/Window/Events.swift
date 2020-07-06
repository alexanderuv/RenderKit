//
// Created by Alexander Ubillus on 7/3/20.
//

import Foundation

public struct KeyboardEvent {

    public enum EventType {
        case pressed,
             released
    }

    public let keyCode: KeyCode
    public let flags: ModifierFlags
    public let type: EventType

    public init(keyCode: KeyCode, flags: ModifierFlags, type: EventType) {
        self.keyCode = keyCode
        self.flags = flags
        self.type = type
    }
}

public enum MouseButton {
    case left,
         right,
         middle
}

public struct MouseEvent {

    public enum EventType {
        case buttonPressed,
             buttonReleased,
             scrolled,
             moved
    }

    public let x: Int
    public let y: Int
    public let type: EventType
    public let button: MouseButton
}

public struct RenderEvent {
}

public struct WindowEvent {

    public enum EventType {
        case close,
             resize
    }

    public let type: EventType

    public init(type: EventType) {
        self.type = type
    }
}