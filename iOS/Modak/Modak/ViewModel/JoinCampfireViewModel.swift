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
    
    init() {
        // 캡처된 이미지가 있을 때 자동으로 텍스트 인식을 수행하도록 설정
        cameraViewModel.textRecognizeHandler = { [weak self] image in
            self?.recognizeText(from: image)
        }
    }

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
    
    public func recognizeText(from image: UIImage) {
        Task {
            let textRecognizer = TextRecognizer()
            do {
                let recognizedText = try await textRecognizer.recognizeText(in: image)
                print("Recognized Text: \(recognizedText)")
                
                DispatchQueue.main.async {
                    // recognizedText를 줄 단위로 나눔
                    let lines = recognizedText.components(separatedBy: .newlines)
                    
                    // "모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요."를 찾은 후, 다음 줄을 roomName으로 설정
                    if let startIndex = lines.firstIndex(where: { $0.contains("모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요.") }),
                       startIndex + 1 < lines.count {
                        
                        var extractedRoomName = lines[startIndex + 1]
                        
                        // "까지" 또는 " 까지"가 포함되어 있으면 그 뒤의 텍스트를 모두 제거
                        if let range = extractedRoomName.range(of: "까지") {
                            extractedRoomName = String(extractedRoomName[..<range.lowerBound])
                        } else if let range = extractedRoomName.range(of: " 까지") {
                            extractedRoomName = String(extractedRoomName[..<range.lowerBound])
                        }
                        
                        
                        self.roomName = extractedRoomName
                    }
                    
                    // "km 남음" 또는 " km 남음"이 포함된 줄에서 점을 제외한 숫자만 추출하여 roomPassword로 설정
                    if let roomPasswordLine = lines.first(where: { $0.contains("km 남음") || $0.contains(" km 남음") }) {
                        let extractedRoomPassword = roomPasswordLine.replacingOccurrences(of: "km 남음", with: "")
                                                                    .replacingOccurrences(of: " km 남음", with: "")
                                                                    .compactMap { $0.isNumber ? String($0) : nil }.joined()
                        
                        self.roomPassword = extractedRoomPassword
                    }
                    
                    print("Room Name: \(self.roomName)")
                    print("Room Password: \(self.roomPassword)")
                }
                
            } catch {
                print("Text recognition failed: \(error)")
            }
        }
    }
}

