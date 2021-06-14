//
// Created by Alexander Ubillus on 7/5/20.
//

import Foundation

public struct Shader {
    public let content: String
    public let vertexFunction: String
    public let fragmentFunction: String

    public init(content: String, vertexFunction: String, fragmentFunction: String) {
        self.content = content
        self.vertexFunction = vertexFunction
        self.fragmentFunction = fragmentFunction
    }
}
