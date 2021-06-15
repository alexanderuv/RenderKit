//
// Created by Alexander Ubillus on 6/14/21.
//

import Foundation
import MetalKit

public protocol MetalEnabled {
    func enableMetal(_ metalLayer: CAMetalLayer)
}