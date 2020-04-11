//
// Created by Alexander Ubillus on 3/30/20.
//

import Foundation
import AppKit
import MetalKit

class ViewController : NSViewController {

    var device: MTLDevice!
    var metalLayer: CAMetalLayer!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!



    let vertexData: [Float] = [
        0.0,  1.0, 0.0,
        -1.0, -1.0, 0.0,
        1.0, -1.0, 0.0
    ]

    let defaultShaders = """
                         vertex float4 basic_vertex(                           // 1
                           const device packed_float3* vertex_array [[ buffer(0) ]], // 2
                           unsigned int vid [[ vertex_id ]]) {                 // 3
                           return float4(vertex_array[vid], 1.0);              // 4
                         }

                         fragment half4 basic_fragment() { // 1
                           return half4(1.0);              // 2
                         }
                         """

    override func loadView() {
        view = NSView(frame: NSScreen.main!.frame)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doMetalStuff()
        render()
    }

    private func doMetalStuff() {
        device = MTLCreateSystemDefaultDevice()

        metalLayer = CAMetalLayer()          // 1
        metalLayer.device = device           // 2
        metalLayer.pixelFormat = .bgra8Unorm // 3
        metalLayer.framebufferOnly = true    // 4
        metalLayer.frame = view.frame  // 5
        view.layer = metalLayer
//        view.layer?.addSublayer(metalLayer)   //

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]) // 1
        
        vertexBuffer = device.makeBuffer(length: dataSize, options: .storageModeManaged) // 2
//        vertexBuffer.contents().storeBytes(of: vertexData, toByteOffset: 0, as: [Float].self)
//        vertexBuffer.contents().copyMemory(from: vertexData, byteCount: MemoryLayout<Float>.stride * vertexData.count)
        let b = vertexBuffer.contents().bindMemory(to: Float.self, capacity: vertexData.count)
        b.assign(from: vertexData, count: vertexData.count)
        vertexBuffer.didModifyRange(0..<dataSize)
        
//        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize, options: .storageModeManaged) // 2
        
        // 1
        let defaultLibrary = try! device.makeLibrary(source: defaultShaders, options: .none)
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")

// 2
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm

// 3
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)

        commandQueue = device.makeCommandQueue()
    
    }

    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(
                red: 0.0,
                green: 104.0/255.0,
                blue: 55.0/255.0,
                alpha: 1.0)

        let commandBuffer = commandQueue.makeCommandBuffer()!

        let renderEncoder = commandBuffer
                .makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder
                .drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3, instanceCount: 1)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

class MyView : NSView {

    override var wantsLayer: Bool {
        get {
            true
        }
        set {

        }
    }
}

class NopeController : NSViewController {
    override func loadView() {
        view = NSView(frame: NSScreen.main!.frame)
    }
}

class TestAppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
    var controller: NSViewController!
    var windowController: NSWindowController!

    func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSWindow(
                contentRect: NSMakeRect(0, 0, CGFloat(800), CGFloat(600)),
                styleMask: [.titled, .closable, .resizable],
                backing: .buffered,
                defer: false)

        controller = ViewController()
        window.contentViewController = controller
//        window.contentView = controller.view
        window.title = "demo"
        window.isOpaque = true
        window.center()

        windowController = NSWindowController()
        windowController.contentViewController = window.contentViewController
        windowController.window = window
        windowController.showWindow(self)
    }
}
