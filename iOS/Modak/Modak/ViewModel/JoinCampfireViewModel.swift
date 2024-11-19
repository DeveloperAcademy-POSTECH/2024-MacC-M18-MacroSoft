//
//  JoinCampfireViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/31/24.
//

import SwiftUI

class JoinCampfireViewModel: ObservableObject {
    @Published var campfireName: String = ""
    @Published var campfirePin: String = ""
    @Published var createdAt: String = ""
    @Published var membersNames: [String] = []
    @Published var isCameraMode: Bool = true
    @Published var showError: Bool = false
    @Published var showSuccess: Bool = false
    @Published var cameraViewModel = CameraViewModel()
    
    @AppStorage("recentVisitedCampfirePin") private var recentVisitedCampfirePin: Int = 0
    
    init() {
        // 캡처된 이미지가 있을 때 자동으로 텍스트 인식을 수행하도록 설정
        cameraViewModel.textRecognizeHandler = { [weak self] image in
            self?.recognizeText(from: image)
        }
    }

    // 유효성 검사 및 서버 통신을 관리
    func validateAndSendCredentials() {
        guard !campfireName.isEmpty, !campfirePin.isEmpty else {
            showError = true
            return
        }

        sendCampfireCredentialsToServer()
    }
    
    // 서버에 요청 전송
    private func sendCampfireCredentialsToServer() {
        Task {
            do {
                let extractedCampfirePin = campfirePin.compactMap { $0.isNumber ? String($0) : nil }.joined()
                
                let data = try await NetworkManager.shared.requestRawData(router: .joinCampfire(campfirePin: Int(extractedCampfirePin) ?? 0, campfireName: campfireName))
                
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = json["result"] as? [String: Any],
                   let joinedCampfirePin = result["campfirePin"] as? Int {
                    
                    DispatchQueue.main.async {
                        self.recentVisitedCampfirePin = joinedCampfirePin
                        self.fetchCampfireInfo(campfirePin: joinedCampfirePin)
                    }
                    print("Successfully joined campfire with PIN: \(joinedCampfirePin)")
                } else {
                    DispatchQueue.main.async {
                        self.showError = true
                    }
                    print("Failed to parse response")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                }
                print("Error sending campfire credentials: \(error)")
            }
        }
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
                    
                    // "모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요."를 찾은 후, 다음 줄을 campfireName으로 설정
                    if let startIndex = lines.firstIndex(where: { $0.contains("모닥불 참여하기를 눌러 하단 이정표를 스캔해 주세요.") || $0.contains("Modak") }),
                       startIndex + 1 < lines.count {
                        
                        var extractedCampfireName = lines[startIndex + 1]
                        
                        // "까지" 또는 " 까지"가 포함되어 있으면 그 위치부터 뒤의 텍스트를 모두 제거
                        if let range = extractedCampfireName.range(of: "까지") ?? extractedCampfireName.range(of: " 까지") {
                            extractedCampfireName = String(extractedCampfireName[..<range.lowerBound])
                        }
                        
                        self.campfireName = extractedCampfireName.trimmingCharacters(in: .whitespacesAndNewlines)
                    }
                    
                    // "km" 이 포함된 줄에서 점을 제외한 숫자만 추출하여 campfirePin로 설정
                    if let campfirePinLine = lines.first(where: { $0.contains("km")}) {
                        let extractedCampfirePin = campfirePinLine.replacingOccurrences(of: "km", with: "")
                                                                    .compactMap { $0.isNumber ? String($0) : nil }.joined()
                        
                        self.campfirePin = extractedCampfirePin
                    }
                    
                    print("Campfire Name: \(self.campfireName)")
                    print("Campfire Pin: \(self.campfirePin)")
                }
                
            } catch {
                print("Text recognition failed: \(error)")
            }
        }
    }
    
    private func fetchCampfireInfo(campfirePin: Int) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .joinCampfireInfo(campfirePin: campfirePin))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any] {
                    
                    DispatchQueue.main.async {
                        self.campfireName = result["campfireName"] as? String ?? ""
                        
                        if let createdAtString = result["createdAt"] as? String {
                            // 옵셔널 언래핑 및 날짜 변환
                            let dateFormatter = DateFormatter()
                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

                            if let createdAtDate = dateFormatter.date(from: createdAtString) {
                                dateFormatter.dateFormat = "yyyy.MM.dd"
                                self.createdAt = dateFormatter.string(from: createdAtDate)
                            } else {
                                self.createdAt = "2024.00.00"
                            }
                        } else {
                            self.createdAt = "2024.00.00"
                        }
                        
                        self.membersNames = result["membersNames"] as? [String] ?? []
                        self.showSuccess = true // BottomSheet 표시
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showError = true
                    }
                    print("Failed to parse campfire info.")
                }
            } catch {
                DispatchQueue.main.async {
                    self.showError = true
                }
                print("Error fetching campfire info: \(error)")
            }
        }
    }
}

