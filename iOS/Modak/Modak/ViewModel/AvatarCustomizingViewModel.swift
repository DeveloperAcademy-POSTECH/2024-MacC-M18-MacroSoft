//
//  AvatarViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SceneKit

class AvatarCustomizingViewModel: ObservableObject {
    @Published var scene: SCNScene
    @Published var selectedItems: [String: String] = [:]
    @Published var selectedCategory: String

    private let avatar: [AvatarData]
    private let items: [ItemData]
    
    init() {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.selectedCategory = items.first?.category ?? ""
        self.scene = SCNScene()
    }

    func availableItems(for category: String) -> [String] {
        return ItemData.sample.first { $0.category == category }?.items ?? []
    }
    
    func selectCategory(category: String) {
        selectedCategory = category
    }

    func applyItemToScene(category: String, item: String) {
        selectedItems[category] = item
        
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
        }
    }
    
    func saveAvatarCustomInfo() {
        print("Selected Items: \(selectedItems.keys) // \(selectedItems.values) // \(selectedItems)")
        let parameters: [String: Any] = [
            "hatType": items.first(where: { $0.category == "Hat" })?.items.firstIndex(of: selectedItems["Hat"] ?? "nil") ?? 0,
            "faceType": items.first(where: { $0.category == "Face" })?.items.firstIndex(of: selectedItems["Face"] ?? "nil") ?? 0,
            "topType": items.first(where: { $0.category == "Top" })?.items.firstIndex(of: selectedItems["Top"] ?? "nil") ?? 0
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
