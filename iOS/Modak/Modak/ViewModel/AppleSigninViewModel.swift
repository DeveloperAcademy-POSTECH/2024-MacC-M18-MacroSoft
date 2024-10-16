//
//  AppleSigninViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/15/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

class AppleSigninViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var shouldReLogin = false // 로그인을 다시 해야 하는지 여부를 저장
    
    let loginURL = URL(string: "https://주소 입력해야 됨") // 소셜 로그인
    let refreshTokenURL = URL(string: "https://주소 입력해야 됨") // Access Token 재발급
    
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        // 인증 결과 처리
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential{
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    // 계정 정보 가져오기
                    let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8)
                    let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8)
                    let userIdentifier = appleIDCredential.user
                    let encryptedUserIdentifier = SHA256.hash(data: Data(userIdentifier.utf8)).compactMap { String(format: "%02x", $0) }.joined()
                    
                    // 값 확인
                    print("Authorization Code: \(authorizationCode ?? "")")
                    print("Identity Token: \(identityToken ?? "")")
                    print("Encrypted User Identifier: \(encryptedUserIdentifier)")
                    
                    // 서버에 값 전송
                    sendCredentialsToServer(authorizationCode: authorizationCode ?? "", identityToken: identityToken ?? "", encryptedUserIdentifier: encryptedUserIdentifier)
                
                    // 로그인 성공
                    self.isLoggedIn = true
                    self.shouldReLogin = false

                default:
                    break
            }
        case .failure(let error):
            print(error.localizedDescription)
            print("error")
            
            // 로그인 실패 시 다시 로그인 필요
            self.isLoggedIn = false
            self.shouldReLogin = true
        }
    }
    
    // 서버로 데이터를 전송하는 함수
    func sendCredentialsToServer(authorizationCode: String, identityToken: String, encryptedUserIdentifier: String) {
        // 서버의 URL
        guard let url = loginURL else {
            print("Invalid URL")
            return
        }
        
        // 전송할 데이터
        let parameters: [String: Any] = [
            "authorizationCode": authorizationCode,
            "identityToken": identityToken,
            "encryptedUserIdentifier": encryptedUserIdentifier
        ]

        // JSON 데이터로 변환
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error encoding parameters")
            return
        }

        // URLRequest 설정
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody

        // 네트워크 요청
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error sending request: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }

            // 서버 응답 처리
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    // 성공적으로 처리됨
                    self.handleServerResponse(data: data)
                case 401, 403:
                    // 토큰이 만료됨
                    self.promptUserToReLogin()
                default:
                    print("Unexpected response code: \(response.statusCode)")
                }
            }
        }

        // 요청 시작
        task.resume()
    }
    
    // 서버 응답 처리 함수
    private func handleServerResponse(data: Data) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let result = jsonResponse["result"] as? [String: Any] {
                
                if let accessToken = result["accessToken"] as? String,
                   let refreshToken = result["refreshToken"] as? String {
                    // 토큰 저장
                    print("accessToken: \(accessToken)")
                    print("refreshToken: \(refreshToken)")
                    setAccessToken(accessToken)
                    setRefreshToken(refreshToken)
                }
            }
        } catch {
            print("Error parsing response: \(error.localizedDescription)")
        }
    }
    
    // refreshToken으로 accessToken을 새로 발급받는 함수
    func refreshAccessToken() {
        guard let refreshToken = getRefreshToken(), let url = refreshTokenURL else {
            print("No valid refreshToken or invalid URL")
            self.shouldReLogin = true
            return
        }
        
        // 전송할 데이터 (refreshToken을 사용하여 accessToken 재발급 요청)
        let parameters: [String: Any] = [
            "refreshToken": refreshToken
        ]
        
        // JSON 데이터로 변환
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            print("Error encoding parameters")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error refreshing access token: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else { return }
            
            // 새 accessToken을 발급받아 처리
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200:
                    self.handleServerResponse(data: data)
                case 401, 403:
                    self.promptUserToReLogin() // refresh토큰도 만료됨
                default:
                    print("Unexpected response code: \(response.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    // 사용자가 다시 로그인하도록 알림을 주는 함수
    func promptUserToReLogin() {
        DispatchQueue.main.async {
            self.shouldReLogin = true // 로그인 필요 상태로 전환
            print("Session expired. Please log in again.")
        }
    }
    
    // 앱 시작 시 자동 로그인 처리
    func attemptAutoLogin() {
        if getRefreshToken() != nil {
            refreshAccessToken() // refreshToken이 있으면 자동으로 accessToken을 재발급 시도
        } else {
            shouldReLogin = true // refreshToken이 없으면 다시 로그인 필요
        }
    }

    // MARK: - AccessToken 관리 (UserDefaults)

    func setAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }

    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    // MARK: - RefreshToken 관리 (Keychain)

    func setRefreshToken(_ token: String) {
        guard let tokenData = token.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "refreshToken",
            kSecValueData as String: tokenData
        ]

        // 기존 값이 있으면 삭제
        SecItemDelete(query as CFDictionary)

        // 새로 저장
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Refresh token saved successfully")
        } else {
            print("Error saving refresh token")
        }
    }

    func getRefreshToken() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "refreshToken",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess, let tokenData = item as? Data else {
            print("Error retrieving refresh token")
            return nil
        }

        return String(data: tokenData, encoding: .utf8)
    }
}
