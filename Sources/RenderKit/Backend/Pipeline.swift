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
    public let vertexLayout: BufferLayout
    public let shader: Shader
    public var colorAttachments = [ColorAttachmentDescriptor()]

    public init(vertexLayout: BufferLayout, shader: Shader) {
        self.vertexLayout = vertexLayout
        self.shader = shader
    }
}

public protocol Pipeline {

}
