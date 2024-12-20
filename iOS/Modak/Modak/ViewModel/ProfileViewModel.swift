//
//  ProfileViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI
import Combine
import SceneKit

class ProfileViewModel: ObservableObject {
    @Published var originalNickname: String = "" // 서버에서 가져온 닉네임
    @Published var scene: SCNScene
    @Published var selectedItems: AvatarItem
    private let avatar: [AvatarData]
    private let items: [ItemData]
    
    init() {
        self.avatar = AvatarData.sample
        self.items = ItemData.sample
        self.scene = SCNScene()
        self.selectedItems = AvatarItem(hatType: 0, faceType: 0, topType: 0)
        
        if let savedItems = loadSelectedItems() {
            self.selectedItems = savedItems
        }
    }
    
    func fetchUserAvatar() async {
        do {
            let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknameAvatar(memberIds: []))
            let decoder = JSONDecoder()
            if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let resultArray = jsonResponse["result"] as? [[String: Any]],
               let firstResult = resultArray.first {
                let jsonData = try JSONSerialization.data(withJSONObject: firstResult, options: [])
                if let myAvatar = try? decoder.decode(MemberAvatar.self, from: jsonData) {
                    DispatchQueue.main.async {
                        self.selectedItems = myAvatar.avatar
                        self.setupScene()
                    }
                }
            }
        } catch {
            print("Error fetching user avatar: \(error)")
        }
    }
    
    func fetchNickname() {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknames)
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultArray = jsonResponse["result"] as? [[String: Any]],
                   let firstResult = resultArray.first,
                   let fetchedNickname = firstResult["nickname"] as? String {
                    DispatchQueue.main.async {
                        self.originalNickname = fetchedNickname
                    }
                } else {
                    print("Failed to fetch nickname")
                }
            } catch {
                print("Error fetching nickname: \(error)")
            }
        }
    }
    
    func saveNickname(newNickname: String, completion: (() -> Void)? = nil) {
        Task {
            do {
                // APIRouter를 통해 URLRequest 생성
                let request = try APIRouter.updateNickname(nickname: newNickname).asURLRequest()
                print("Request URL:", request.url?.absoluteString ?? "No URL")
                print("Request Headers:", request.allHTTPHeaderFields ?? "No headers")
                print("Request Body:", String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "No body")
                
                // 서버로 요청
                let data = try await NetworkManager.shared.requestRawData(router: .updateNickname(nickname: newNickname))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any],
                   let nickname = result["nickname"] as? String {
                    
                    DispatchQueue.main.async {
                        self.originalNickname = nickname
                        print("Nickname successfully changed to: \(self.originalNickname)")
                        completion?()
                    }
                } else {
                    print("Failed to update nickname on server")
                }
            } catch {
                print("Error updating nickname: \(error)")
            }
        }
    }
    
    func logout(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .logout)
                
                if try JSONSerialization.jsonObject(with: data, options: []) is [String: Any] {
                    print("Logout successful")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("Failed to logout")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("Error logging out: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func deactivate(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .deactivate)
                
                if try JSONSerialization.jsonObject(with: data, options: []) is [String: Any] {
                    print("Deactivation successful")
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    print("Failed to deactivate account")
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("Error deactivating account: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        }
    }
    
    func loadSelectedItems() -> AvatarItem? {
        if let savedData = UserDefaults.standard.data(forKey: "selectedItems") {
            let decoder = JSONDecoder()
            return try? decoder.decode(AvatarItem.self, from: savedData)
        }
        return nil
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
    
    func setupScene() {
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
            if selectedItems.hatType > 0, let hatNode = createNode(named: "hat\(selectedItems.hatType).scn") {
                avatarNode.addChildNode(hatNode)
            }
            if selectedItems.faceType > 0, let faceNode = createNode(named: "face\(selectedItems.faceType).scn") {
                avatarNode.addChildNode(faceNode)
            }
            if selectedItems.topType > 0, let topNode = createNode(named: "top\(selectedItems.topType).scn") {
                avatarNode.addChildNode(topNode)
            }
        }
    }
}

