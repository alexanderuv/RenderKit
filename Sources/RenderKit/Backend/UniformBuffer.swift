//
// Created by Alexander Ubillus on 7/11/20.
//

import Foundation

public protocol UniformBuffer {
    func updateContents<T>(_ content: T)
    func unwrap() -> Any? 
}
