import SwiftUI
import SceneKit

struct RotateView: View {
    @State private var scene = SCNScene()
    @State private var cubeNode = SCNNode()
    @State private var rotationX: CGFloat = 0.0
    @State private var rotationY: CGFloat = 0.0
    @State private var isReturning = false
    
    var body: some View {
        ZStack {
            SceneView(
                scene: scene,
                pointOfView: nil,
                options: [.allowsCameraControl],
                preferredFramesPerSecond: 60,
                antialiasingMode: .multisampling4X
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isReturning = false
                        let newRotationX = rotationX + value.translation.height / 100
                        let newRotationY = rotationY + value.translation.width / 100
                        updateCubeRotation(x: newRotationX, y: newRotationY)
                    }
                    .onEnded { _ in
                        withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                            rotationX = 0
                            rotationY = 0
                            updateCubeRotation(x: 0, y: 0)
                            isReturning = true
                        }
                    }
            )
            .frame(width: 300, height: 300)
            .onAppear {
                setupScene()
            }
        }
    }
    
    // Установка начальной сцены с кубом
    func setupScene() {
        // Создаём куб
        let cubeGeometry = SCNBox(width: 2, height: 2, length: 2, chamferRadius: 0)
        cubeGeometry.firstMaterial?.diffuse.contents = UIColor.green
        cubeNode = SCNNode(geometry: cubeGeometry)
        cubeNode.position = SCNVector3(0, 0, 0)
        
        let geom = SCNBox(width: 3, height: 3, length: 3, chamferRadius: 0)
        geom.firstMaterial?.diffuse.contents = UIColor.red
        var geomNode = SCNNode(geometry: geom)
        scene.rootNode.addChildNode(geomNode)
        
        // Добавляем куб в сцену
        scene.rootNode.addChildNode(cubeNode)
        
        // Устанавливаем камеру
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 5) // Располагаем камеру перед кубом
        scene.rootNode.addChildNode(cameraNode)
        
        // Добавляем источник света
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(0, 10, 10)
        lightNode.rotation = SCNVector4(x: -34, y: 0, z: 0, w: 0)
        scene.rootNode.addChildNode(lightNode)
    }
    
    // Обновление поворота куба
    func updateCubeRotation(x: CGFloat, y: CGFloat) {
        cubeNode.eulerAngles.x = Float(x)
        cubeNode.eulerAngles.y = Float(y)
        rotationX = x
        rotationY = y
    }
}

#Preview {
    RotateView()
}
