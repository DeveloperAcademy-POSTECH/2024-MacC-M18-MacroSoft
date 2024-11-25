//
//  CampfireMemberDetailViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SwiftUI
import Combine
import SceneKit

class CampfireMemberDetailViewModel: ObservableObject {
    @Published var scene: SCNScene
    @Published var memberAvatars: [MemberAvatar] = []
    @Published var memberViewModels: [Int: CampfireMemberDetailViewModel] = [:]
    
    private let avatar: [AvatarData]
    private let items: [ItemData]
    
    init() {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.scene = SCNScene()
    }
    
    func fetchMemberAvatars(memberIds: [Int]) async {
        do {
            let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknameAvatar(memberIds: memberIds))
            let decoder = JSONDecoder()
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let resultArray = jsonResponse["result"] as? [[String: Any]] {
                let jsonData = try JSONSerialization.data(withJSONObject: resultArray, options: [])
                let avatars = try decoder.decode([MemberAvatar].self, from: jsonData)
                
                DispatchQueue.main.async {
                    self.memberAvatars = avatars
                    self.initializeMemberViewModels()
                }
            } else {
                print("Unexpected API response structure.")
            }
        } catch {
            print("Error fetching member avatars: \(error)")
        }
    }
    
    func initializeMemberViewModels() {
        for member in memberAvatars {
            if memberViewModels[member.memberId] == nil {
                let viewModel = CampfireMemberDetailViewModel()
                viewModel.setupScene(for: member.avatar)
                memberViewModels[member.memberId] = viewModel
            }
        }
    }
    
    private func createNode(named name: String) -> SCNNode? {
        guard let scene = SCNScene(named: name) else {
            print("Failed to load \(name)")
            return nil
        }
        let newNode = scene.rootNode.clone()
        if name.contains("avatar") {
            newNode.position = avatar[0].position
            newNode.rotation = avatar[0].rotation
        }
        return newNode
    }
    
    func setupScene(for avatar: AvatarItem) {
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
            scene.rootNode.addChildNode(avatarNode)
            
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
        }
    }
}
