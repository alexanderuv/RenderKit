//
// Created by Alexander Ubillus on 7/1/20.
//

import Foundation

public enum KeyCode {
    // numbers
    case key0, key1, key2, key3, key4, key5, key6, key7, key8, key9

    // letters
    case keyA, keyB, keyC, keyD, keyE, keyF, keyG, keyH, keyI, keyJ,
         keyK, keyL, keyM, keyN, keyO, keyP, keyQ, keyR, keyS, keyT,
         keyU, keyV, keyW, keyX, keyY, keyZ

    // symbols
    case keyApostrophe,
         keyBackslash,
         keyComma,
         keyEqual,
         keyGraveAccent,
         keyLeftBracket,
         keyMinus,
         keyPeriod,
         keyRightBracket,
         keySemicolon,
         keySlash

    case keyBackspace,
         keyCapsLock,
         keyDelete,
         keyDown,
         keyEnd,
         keyEnter,
         keyEscape

    case keyF1, keyF2, keyF3, keyF4, keyF5, keyF6, keyF7, keyF8, keyF9, keyF10,
         keyF11, keyF12, keyF13, keyF14, keyF15, keyF16, keyF17, keyF18, keyF19, keyF20

    case keyHome,
         keyInsert,
         keyLeft,
         keyLeftAlt,
         keyLeftControl,
         keyLeftShift,
         keyLeftSuper,
         keyMenu,
         keyNumLock,
         keyPageDown,
         keyPageUp,
         keyRight,
         keyRightAlt,
         keyRightControl,
         keyRightShift,
         keyRightSuper,
         keySpace,
         keyTab,
         keyUp

    case keyNumPad0,
         keyNumPad1,
         keyNumPad2,
         keyNumPad3,
         keyNumPad4,
         keyNumPad5,
         keyNumPad6,
         keyNumPad7,
         keyNumPad8,
         keyNumPad9,
         keyNumPadAdd,
         keyNumPadDecimal,
         keyNumPadDivide,
         keyNumPadEnter,
         keyNumPadEqual,
         keyNumPadMultiply,
         keyNumPadSubtract
}

public struct ModifierFlags: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }

    public static var capsLock = ModifierFlags(rawValue: 1 << 0)
    public static var shift = ModifierFlags(rawValue: 1 << 1)
    public static var control = ModifierFlags(rawValue: 1 << 2)
    public static var alt = ModifierFlags(rawValue: 1 << 3)
    public static var command = ModifierFlags(rawValue: 1 << 4)
    public static var numericPad = ModifierFlags(rawValue: 1 << 5)
    public static var function = ModifierFlags(rawValue: 1 << 6)
}