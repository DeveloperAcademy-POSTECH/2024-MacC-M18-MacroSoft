//
//  CampfireViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/6/24.
//

import SwiftUI
import Combine

class CampfireViewModel: ObservableObject {
    @Published var campfire: Campfire?
    @Published var isEmptyCampfire: Bool = true
    @Published var showNetworkAlert: Bool = false
    @AppStorage("recentVisitedCampfirePin") var recentVisitedCampfirePin: Int = 0
    
    init() {
        fetchCampfireMainInfo()
    }
    
    func fetchCampfireMainInfo() {
        if recentVisitedCampfirePin != 0 {
            fetchCampfireMainInfo(for: recentVisitedCampfirePin)
        } else {
            fetchUserCampfireInfos()
        }
    }
    
    // 특정 캠프파이어 핀으로 메인 화면 정보를 가져옴
    private func fetchCampfireMainInfo(for campfirePin: Int) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getCampfireMainInfo(campfirePin: campfirePin))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any] {
                    
                    // Campfire 모델에 대한 JSON 응답 디코딩
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: [])
                    let campfire = try JSONDecoder().decode(Campfire.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.campfire = campfire
                        self.isEmptyCampfire = false
                    }
                } else {
                    print("Failed to parse campfire info.")
                    DispatchQueue.main.async {
                        self.isEmptyCampfire = true
                    }
                }
            } catch {
                print("Error fetching campfire info: \(error)")
                DispatchQueue.main.async {
                    self.isEmptyCampfire = true
                }
            }
        }
    }
    
    // 사용자가 참여한 모든 캠프파이어 목록에서 첫 번째 캠프파이어 정보를 가져옴
    private func fetchUserCampfireInfos() {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMyCampfires)
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any],
                   let campfireInfos = result["campfireInfos"] as? [[String: Any]],
                   let firstCampfireInfo = campfireInfos.first {
                    
                    // Campfire 모델에 대한 JSON 응답 디코딩
                    let jsonData = try JSONSerialization.data(withJSONObject: firstCampfireInfo, options: [])
                    let campfire = try JSONDecoder().decode(Campfire.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.campfire = campfire
                        self.isEmptyCampfire = false
                        // 첫 번째 캠프파이어 핀을 recentVisitedCampfirePin으로 저장
                        self.recentVisitedCampfirePin = campfire.pin

                    }
                } else {
                    print("User has no campfire.")
                    DispatchQueue.main.async {
                        self.isEmptyCampfire = true
                    }
                }
            } catch {
                print("Error fetching user campfire infos: \(error)")
                DispatchQueue.main.async {
                    self.isEmptyCampfire = true
                }
            }
        }
    }
    
    func showTemporaryNetworkAlert() {
        withAnimation {
            self.showNetworkAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showNetworkAlert = false
            }
        }
    }
}



