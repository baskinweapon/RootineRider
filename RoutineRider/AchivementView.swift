import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    var number: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.delegate = context.coordinator
        return metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.number = number
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        var parent: MetalView
        var number: Int = 1
        var commandQueue: MTLCommandQueue!
        var pipelineState: MTLRenderPipelineState!
        
        init(_ parent: MetalView) {
            self.parent = parent
            super.init()
            
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Metal is not supported on this device")
            }
            
            commandQueue = device.makeCommandQueue()
            let library = device.makeDefaultLibrary()
            let vertexFunction = library?.makeFunction(name: "vertex_main")
            let fragmentFunction = library?.makeFunction(name: "fragment_main")
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let passDescriptor = view.currentRenderPassDescriptor else { return }
            
            let commandBuffer = commandQueue.makeCommandBuffer()
            let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: passDescriptor)
            renderEncoder?.setRenderPipelineState(pipelineState)
            
            // Set number to Metal shader for shape and color adjustment
            renderEncoder?.setFragmentBytes(&number, length: MemoryLayout<Int>.stride, index: 0)
            
            // Draw a shape based on the number
            renderEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: number * 3)
            
            renderEncoder?.endEncoding()
            commandBuffer?.present(drawable)
            commandBuffer?.commit()
        }
    }
}

struct AchievmentView: View {
    @State private var number: Int = 1
    
    var body: some View {
        VStack {
            MetalView(number: number)
                .frame(height: 400)
            
            Slider(value: Binding(get: {
                Double(number)
            }, set: { newValue in
                number = Int(newValue)
            }), in: 1...10, step: 1)
                .padding()
            
            Text("Selected number: \(number)")
        }
    }
}

#Preview {
    AchievmentView()
}

