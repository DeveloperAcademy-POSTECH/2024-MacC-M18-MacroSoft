//
//  CampfireMainAvatarView.swift
//  Modak
//
//  Created by kimjihee on 11/26/24.
//

import SwiftUI
import SceneKit
import Lottie

struct CampfireMainAvatarView: View {
    @State private var scene = SCNScene()
    @State private var avatars: [AvatarData] = AvatarData.sample2
    
    var body: some View {
        ZStack(alignment: .center) {
            // scene 추가
            CustomSCNView(scene: scene)
//            SceneView(
//                scene: scene,
//                options: [.allowsCameraControl, .autoenablesDefaultLighting]
//            )
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                setupScene()
            }
            .frame(height: 480)
            
            LottieView(filename: "fireTest")
                .frame(width: 500, height: 500)
                .padding(.top, 160)
        }
    }
    
    private func setupScene() {
        // 기존 노드 제거
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        // 배경 설정
//        scene.background.contents = UIColor.systemGray6
        
        // 카메라 추가
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.contrast = 1.3
        cameraNode.position = SCNVector3(0, -4.7, 1.8)
        cameraNode.look(at: SCNVector3(0, 4.7, 1.4))
        scene.rootNode.addChildNode(cameraNode)
        
        // 측면
        let lightNode1 = SCNNode()
        lightNode1.light = SCNLight()
        lightNode1.light?.type = .IES
        lightNode1.light?.intensity = 30
        lightNode1.light?.color = UIColor(red: 0.912, green: 0.343, blue: 0.711, alpha: 1.0)
        lightNode1.position = SCNVector3(-2.8, 0, 0)
        lightNode1.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode1)
        
        // 측면2
        let lightNode4 = SCNNode()
        lightNode4.light = SCNLight()
        lightNode4.light?.type = .IES
        lightNode4.light?.intensity = 30
        lightNode4.light?.color = UIColor(red: 0.912, green: 0.343, blue: 0.711, alpha: 1.0)
        lightNode4.position = SCNVector3(3.0, 0.1, 0)
        lightNode4.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode4)
        
        // 전면
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .spot
        lightNode2.light?.intensity = 600
        lightNode2.light?.color = UIColor(red: 0.9, green: 0.75, blue: 0.7, alpha: 1.0)
        lightNode2.position = SCNVector3(0.0, -10, 5)
        lightNode2.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode2)
        
        // 전면 2
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light?.type = .IES
        lightNode3.light?.intensity = 60
        lightNode3.light?.color = UIColor(red: 0.912, green: 0.343, blue: 0.021, alpha: 1.0)
        lightNode3.position = SCNVector3(0.3, 0.1, 0)
        lightNode3.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode3)
        
        // 아바타 배치
        for avatar in avatars {
            if let avatarNode = createAvatarNode(named: "avatar.scn") {
                avatarNode.position = avatar.position
                avatarNode.rotation = avatar.rotation
                scene.rootNode.addChildNode(avatarNode)
            }
        }
    }
    
    private func createAvatarNode(named name: String) -> SCNNode? {
        guard let objScene = SCNScene(named: name) else { return nil }
        let avatarNode = objScene.rootNode.childNodes.first?.clone()
        avatarNode?.scale = SCNVector3(0.5, 0.5, 0.5) // 아바타 크기 조정
        return avatarNode
    }
}

#Preview {
    CampfireMainAvatarView()
}
