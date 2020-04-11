//
// Created by Alexander Ubillus on 3/29/20.
//

import Foundation

public enum PixelFormat {
    case bgra8Unorm
}

public struct ColorAttachmentDescriptor {
    public var pixelFormat = PixelFormat.bgra8Unorm
}

public struct PipelineDescriptor {
    public var vertexShader: String?
    public var fragmentShader: String?
    public var colorAttachments = [ColorAttachmentDescriptor()]

    public init() {
    }
}

public protocol Pipeline {

}
