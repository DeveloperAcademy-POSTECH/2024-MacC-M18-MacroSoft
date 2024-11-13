//
//  ProfileViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var originalNickname: String = "" // 서버에서 가져온 닉네임
    
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
            // TODO: API 통신을 통해 닉네임을 변경하고 저장하는 로직 추가
            DispatchQueue.main.async {
                self.originalNickname = newNickname
                print("Nickname changed to: \(self.originalNickname)")
                completion?()
            }
        }
    }
}
