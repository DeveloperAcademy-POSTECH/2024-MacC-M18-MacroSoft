//
//  CampfireMemberDetailViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SwiftUI
import Combine
import SceneKit

class AvatarViewModel: ObservableObject {
    @Published var scene: SCNScene
    @Published var memberAvatars: [MemberAvatar] = []
    @Published var memberViewModels: [Int: AvatarViewModel] = [:]
    
    var avatar: [AvatarData]
    private let items: [ItemData]
    
    init() {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.scene = SCNScene()
    }
    
    func setupScene1(for avatar: AvatarItem) {
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
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
        lightNode1.position = SCNVector3(-2, 0, 0)
        lightNode1.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode1)
        
        // 전면
        let lightNode2 = SCNNode()
        lightNode2.light = SCNLight()
        lightNode2.light?.type = .spot
        lightNode2.light?.intensity = 600
        lightNode2.light?.color = UIColor(red: 0.9, green: 0.75, blue: 0.7, alpha: 1.0)
        lightNode2.position = SCNVector3(4.6, -10, 5)
        lightNode2.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode2)
        
        // 바닥
        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light?.type = .IES
        lightNode3.light?.intensity = 1100
        lightNode3.light?.color = UIColor(red: 0.0, green: 0.0, blue: 0.2, alpha: 0.0)
        lightNode3.position = SCNVector3(0, 0, -2)
        lightNode3.look(at: SCNVector3(0, 1.8, 0))
        scene.rootNode.addChildNode(lightNode3)
        
        // 아바타 추가
        if let avatarNode = createNode(named: "avatar.scn") {
            avatarNode.position = self.avatar[0].position
            avatarNode.rotation = self.avatar[0].rotation
            
            // 아이템 추가
            if avatar.hatType > 0, let hatNode = createNode(named: "hat\(avatar.hatType).scn") {
                avatarNode.addChildNode(hatNode)
            }
            if avatar.faceType > 0, let faceNode = createNode(named: "face\(avatar.faceType).scn") {
                avatarNode.addChildNode(faceNode)
            }
            if avatar.topType > 0, let topNode = createNode(named: "top\(avatar.topType).scn") {
                avatarNode.addChildNode(topNode)
            }
            
            scene.rootNode.addChildNode(avatarNode)
        }
    }
    
    func setupScene2() {
        // 기존 노드 제거
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
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
        for (index, member) in memberAvatars.prefix(avatar.count).enumerated() {
            let avatarData = avatar[index]
            if let avatarNode = createNode(named: "avatar.scn") {
                avatarNode.scale = SCNVector3(0.5, 0.5, 0.5)
                avatarNode.position = avatarData.position
                avatarNode.rotation = avatarData.rotation
                
                // 멤버 아이템을 자식 노드로 추가
                if let hatNode = createNode(named: "hat\(member.avatar.hatType).scn") {
                    avatarNode.addChildNode(hatNode)
                }
                if let faceNode = createNode(named: "face\(member.avatar.faceType).scn") {
                    avatarNode.addChildNode(faceNode)
                }
                if let topNode = createNode(named: "top\(member.avatar.topType).scn") {
                    avatarNode.addChildNode(topNode)
                }
                
                scene.rootNode.addChildNode(avatarNode)
            }
        }
    }
    
    private func createNode(named name: String) -> SCNNode? {
        guard let objScene = SCNScene(named: name) else { return nil }
        let itemNode = objScene.rootNode.childNodes.first?.clone()
        return itemNode
    }
}
