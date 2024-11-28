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
    @Published var memberEmotions: [Emotion] = []
    
    var avatar: [AvatarData]
    private let items: [ItemData]
    
    init() {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.scene = SCNScene()
    }
    
    func fetchMemberAvatars(memberIds: [Int]) async {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknameAvatar(memberIds: memberIds))
                let decoder = JSONDecoder()
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultArray = jsonResponse["result"] as? [[String: Any]] {
                    let jsonData = try JSONSerialization.data(withJSONObject: resultArray, options: [])
                    let fetchedAvatars = try decoder.decode([MemberAvatar].self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.memberAvatars = fetchedAvatars
                        print(">>> fetchedAvatars :\(fetchedAvatars)")
                        self.avatar = AvatarData.sample2
                        self.setupScene2()
                    }
                } else {
                    print("Unexpected API response structure.")
                }
            } catch {
                print("Error fetching member avatars: \(error)")
            }
        }
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
                
                // 닉네임 추가
                let nicknamePosition = SCNVector3(0, 0, index%2 != 0 ? 3.5 : 3.9)
                let textNode = createTextNode(text: member.nickname, position: nicknamePosition)
                avatarNode.addChildNode(textNode)
                
                print("members emotion3 : \(String(describing: memberEmotions))")
                // 감정 이모지 추가 (닉네임 위에 표시) let emojiNode = SKLabelNode(text: "😀")
                if let emotion = memberEmotions.first(where: { $0.memberNickname == member.nickname })?.emotion {
                    let emotionPosition = SCNVector3(nicknamePosition.x, nicknamePosition.y, nicknamePosition.z + 0.5)
                    let emotionNode = createEmotionNode(text: emotion, position: emotionPosition)
                    avatarNode.addChildNode(emotionNode)
                }
                
                scene.rootNode.addChildNode(avatarNode)
            }
        }
    }
    
    private func createTextNode(text: String, position: SCNVector3) -> SCNNode {
        // SCNText 생성
        let textGeometry = SCNText(string: text, extrusionDepth: 0)
        textGeometry.font = UIFont(name: "Pretendard-Medium", size: 0.54) ?? UIFont.systemFont(ofSize: 0.54)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.8)
        textGeometry.firstMaterial?.isDoubleSided = true
        
        // 텍스트 노드 생성
        let textNode = SCNNode(geometry: textGeometry)
        textNode.scale = SCNVector3(0.6, 0.6, 0.6)
        
        // 텍스트의 bounding box를 사용하여 크기 계산
        let (min, max) = textGeometry.boundingBox
        let textWidth = max.x - min.x
        let textHeight = max.y - min.y
        
        // 배경 크기 동적으로 설정 (텍스트 크기 + 여백 추가)
        let padding: CGFloat = 10
        let backgroundWidth = (textWidth * 0.6) + Float(padding) / 20.0
        let backgroundHeight = (textHeight * 0.6) + Float(padding) / 30.0
        
        // 둥근 모서리 사각형 생성
        let backgroundPlane = SCNPlane(width: CGFloat(backgroundWidth), height: CGFloat(backgroundHeight))
        backgroundPlane.cornerRadius = CGFloat(backgroundHeight / 2)
        backgroundPlane.firstMaterial?.diffuse.contents = UIColor.black.withAlphaComponent(0.4)
        backgroundPlane.firstMaterial?.isDoubleSided = true
        
        let backgroundNode = SCNNode(geometry: backgroundPlane)
        backgroundNode.position = SCNVector3(0, 0, -0.01)
        
        // 텍스트 중심 맞추기
        textNode.pivot = SCNMatrix4MakeTranslation((min.x + textWidth / 2), (min.y + textHeight / 2), 0)
        textNode.position = SCNVector3(0, 0, 0.01)
        
        // 텍스트와 배경을 담을 컨테이너 노드 생성
        let containerNode = SCNNode()
        containerNode.addChildNode(backgroundNode)
        containerNode.addChildNode(textNode)
        
        // 컨테이너의 위치 설정
        containerNode.position = position
        containerNode.constraints = [SCNBillboardConstraint()] // 카메라를 항상 바라보게 설정
        
        return containerNode
    }
    
    private func createEmotionNode(text: String, position: SCNVector3) -> SCNNode {
        guard let emojiImage = createEmojiImage(from: text, size: 128) else {
            print("Failed to create emoji image")
            return SCNNode()
        }

        let material = SCNMaterial()
        material.diffuse.contents = emojiImage
        material.isDoubleSided = true

        let plane = SCNPlane(width: 0.8, height: 0.8)
        plane.firstMaterial = material

        let emojiNode = SCNNode(geometry: plane)
        emojiNode.position = SCNVector3(position.x, position.y, position.z)
        emojiNode.constraints = [SCNBillboardConstraint()]

        return emojiNode
    }

    private func createEmojiImage(from text: String, size: CGFloat) -> UIImage? {
        // Create a UILabel to render the emoji
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.sizeToFit()

        // Render the UILabel into an UIImage
        let renderer = UIGraphicsImageRenderer(size: label.bounds.size)
        return renderer.image { context in
            label.layer.render(in: context.cgContext)
        }
    }
    
    private func createNode(named name: String) -> SCNNode? {
        guard let objScene = SCNScene(named: name) else { return nil }
        let itemNode = objScene.rootNode.childNodes.first?.clone()
        return itemNode
    }
}
