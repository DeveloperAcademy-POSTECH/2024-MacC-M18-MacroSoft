//
//  AvatarViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SceneKit

class AvatarCustomizingViewModel: ObservableObject {
    @Published var scene: SCNScene
    @Published var selectedItems: AvatarItem
    @Published var selectedCategory: String

    private let avatar: [AvatarData]
    private let items: [ItemData]
    
    init(sharedItems: AvatarItem) {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.selectedCategory = items.first?.category ?? ""
        self.scene = SCNScene()
        self.selectedItems = sharedItems
        
        // UserDefaults에서 저장된 선택 데이터를 불러오기
        if let savedItems = self.loadSelectedItems() {
            self.selectedItems = savedItems
        }
    }

    func availableItems(for category: String) -> [String] {
        return ItemData.sample.first { $0.category == category }?.items ?? []
    }
    
    func selectCategory(category: String) {
        selectedCategory = category
    }
    
    func isSelected(item: String, in category: String) -> Bool {
        switch category {
        case "Hat":
            return availableItems(for: "Hat")[selectedItems.hatType] == item
        case "Face":
            return availableItems(for: "Face")[selectedItems.faceType] == item
        case "Top":
            return availableItems(for: "Top")[selectedItems.topType] == item
        default:
            return false
        }
    }

    func applyItemToScene(category: String, item: String) {
        // 카테고리별로 `selectedItems` 속성 업데이트
        switch category {
        case "Hat":
            selectedItems.hatType = items.first { $0.category == "Hat" }?.items.firstIndex(of: item) ?? 0
        case "Face":
            selectedItems.faceType = items.first { $0.category == "Face" }?.items.firstIndex(of: item) ?? 0
        case "Top":
            selectedItems.topType = items.first { $0.category == "Top" }?.items.firstIndex(of: item) ?? 0
        default:
            break
        }
        
        // 기존 노드 제거
        scene.rootNode.childNodes.filter { $0.name == category }.forEach { $0.removeFromParentNode() }
        
        // 새 노드 추가
        if item != "nil", let newNode = createNode(named: "\(item).scn") {
            newNode.name = category
            scene.rootNode.addChildNode(newNode)
        }
    }

    private func createNode(named name: String) -> SCNNode? {
        guard let scene = SCNScene(named: name) else {
            print("Failed to load \(name)")
            return nil
        }
        let newNode = scene.rootNode.clone()
        newNode.position = avatar[0].position
        newNode.rotation = avatar[0].rotation
        return newNode
    }

    func setupScene() {
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }
        
        // 배경 설정
        DispatchQueue.main.async {
            if let backgroundImage = ProfileBackground().asUIImage(size: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)) {
                self.scene.background.contents = backgroundImage
            } else {
                print("Failed to convert ProfileBackground to UIImage")
            }
        }
        
        // 카메라 추가
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.camera?.contrast = 1.3
        cameraNode.position = SCNVector3(0, -4.7, 1.8)
        cameraNode.look(at: SCNVector3(0, 4.7, 1.4))
        scene.rootNode.addChildNode(cameraNode)
        
        // 중심 축 노드, 카메라 회전 애니메이션 추가
        let rotationNode = SCNNode()
        rotationNode.position = SCNVector3(0, 0, 0)
        rotationNode.rotation = SCNVector4(0, 0, 1, 0.15)
        scene.rootNode.addChildNode(rotationNode)
        rotationNode.addChildNode(cameraNode)
        let rotateRight = SCNAction.rotateBy(x: 0, y: 0, z: 0.6, duration: 5.0)
        let rotateLeft = SCNAction.rotateBy(x: 0, y: 0, z: -0.6, duration: 5.0)
        let sequence = SCNAction.sequence([rotateRight, rotateLeft])
        let repeatAction = SCNAction.repeatForever(sequence)
        rotationNode.runAction(repeatAction)
        
        
        // 바닥 추가
        let floor = SCNFloor()
        floor.reflectivity = 0.001
        floor.firstMaterial = SCNMaterial()
        floor.firstMaterial?.diffuse.contents = UIColor.backgroundDefault
        floor.firstMaterial?.lightingModel = .constant
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(0, 0, 0)
        floorNode.rotation = SCNVector4(1, 1, 1, 90)
        scene.rootNode.addChildNode(floorNode)
        
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
        lightNode2.light?.castsShadow = true
        lightNode2.light?.shadowColor = UIColor.black.withAlphaComponent(0.4)
        lightNode2.light?.shadowRadius = 10.0
        lightNode2.light?.shadowMode = .deferred
        lightNode2.light?.shadowSampleCount = 32
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
            
            // 선택된 아이템 적용
            let hatItem = availableItems(for: "Hat").self[selectedItems.hatType]
            applyItemToScene(category: "Hat", item: hatItem)
            
            let faceItem = availableItems(for: "Face").self[selectedItems.faceType]
            applyItemToScene(category: "Face", item: faceItem)
            
            let topItem = availableItems(for: "Top").self[selectedItems.topType]
            applyItemToScene(category: "Top", item: topItem)
        }
    }
    
    private func saveSelectedItems() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedItems) {
            UserDefaults.standard.set(encoded, forKey: "selectedItems")
        }
    }
    
    func loadSelectedItems() -> AvatarItem? {
        if let savedData = UserDefaults.standard.data(forKey: "selectedItems") {
            let decoder = JSONDecoder()
            return try? decoder.decode(AvatarItem.self, from: savedData)
        }
        return nil
    }
    
    func saveAvatarCustomInfo() {
        print("Selected Items: \(selectedItems)")
        
        saveSelectedItems() // UserDefaults에 저장
        
        let parameters: [String: Any] = [
            "hatType": selectedItems.hatType,
            "faceType": selectedItems.faceType,
            "topType": selectedItems.topType
        ]
        
        Task {
            do {
                _ = try APIRouter.updateAvatar(parameters: parameters).asURLRequest()
                let data = try await NetworkManager.shared.requestRawData(router: .updateAvatar(parameters: parameters))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any] {
                    print("Avatar updated successfully: \(result)")
                } else {
                    print("Failed to update avatar on server.")
                }
            } catch {
                print("Error updating avatar: \(error)")
            }
        }
    }
}
