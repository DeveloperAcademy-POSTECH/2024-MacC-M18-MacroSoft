//
//  JoinCampfireViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/31/24.
//

import SwiftUI

class JoinCampfireViewModel: ObservableObject {
    @Published var roomName: String = ""
    @Published var roomPassword: String = ""
    @Published var isCameraMode: Bool = false
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var cameraViewModel = CameraViewModel()

    // 유효성 검사 및 서버 통신을 관리
    func validateAndSendCredentials() {
        guard !roomName.isEmpty, !roomPassword.isEmpty else {
            showError = true
            return
        }

        sendRoomCredentialsToServer()
    }
    
    // 서버에 요청 전송 -> 예시 함수 (아직 api 안나옴)
    private func sendRoomCredentialsToServer() {
        // 서버의 URL
        guard let url = URL(string: "not yet") else { return }
        
        // 전송할 데이터
        let parameters: [String: Any] = [
            "roomName": roomName,
            "roomPassword": roomPassword
        ]
        
        // JSON 데이터로 변환
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error sending request: \(error.localizedDescription)")
                    self?.showError = true
                    return
                }
                
//                guard let data = data else { return }
                
                // 서버 응답 처리
                if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200:
                        self?.showSuccess = true
                    default:
                        self?.showError = true
                    }
                }
            }
        }
        task.resume()
    }
}

