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
        
    func handleAppleSignIn(result: Result<ASAuthorization, Error>) {
        // 인증 결과 처리
        switch result {
        case .success(let authResults):
            print("Apple Login Successful")
            switch authResults.credential{
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    // 계정 정보 가져오기
                    let authorizationCode = String(data: appleIDCredential.authorizationCode!, encoding: .utf8) ?? ""
                    let identityToken = String(data: appleIDCredential.identityToken!, encoding: .utf8) ?? ""
                    let userIdentifier = appleIDCredential.user
                    let encryptedUserIdentifier = SHA256.hash(data: Data(userIdentifier.utf8)).compactMap { String(format: "%02x", $0) }.joined()
                    
                    // 값 확인
                    print("Authorization Code: \(authorizationCode)")
                    print("Identity Token: \(identityToken)")
                    print("Encrypted User Identifier: \(encryptedUserIdentifier)")
                    
                    // 서버에 값 전송
                    sendCredentialsToServer(authorizationCode: authorizationCode, identityToken: identityToken, encryptedUserIdentifier: encryptedUserIdentifier)

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
        let parameters: [String: Any] = [
            "authorizationCode": authorizationCode,
            "identityToken": identityToken,
            "encryptedUserIdentifier": encryptedUserIdentifier
        ]
        
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .socialLogin(socialType: "APPLE", parameters: parameters))
                handleLoginResponse(data)
            } catch {
                // 다시 로그인 필요
                self.isLoggedIn = false
                self.shouldReLogin = true
                promptUserToReLogin()
            }
        }
    }
    
    // 서버 응답 처리
    private func handleLoginResponse(_ data: Data) {
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
                    
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                    }
                }
            } else {
                promptUserToReLogin()
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                }
            }
        } catch {
            promptUserToReLogin()
            DispatchQueue.main.async {
                self.isLoggedIn = false
            }
        }
    }
    
    // refreshToken으로 accessToken 갱신
    func refreshAccessToken() {
        guard let refreshToken = getRefreshToken() else {
            self.shouldReLogin = true
            return
        }
        
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .refreshAccessToken(refreshToken: refreshToken))
                handleTokenRefreshResponse(data)
            } catch {
                print("Error refreshing access token:", error)
                promptUserToReLogin()
            }
        }
    }
    
    // 토큰 갱신 응답 처리
    private func handleTokenRefreshResponse(_ data: Data) {
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let result = jsonResponse["result"] as? [String: Any] { // 'result' 딕셔너리 추출
                if let accessToken = result["accessToken"] as? String {
                    // 토큰 저장
                    setAccessToken(accessToken)
                    print("Token refreshed successfully.")
                }
            } else {
                print("promptUserToReLogin Error: Missing access token in response.")
                promptUserToReLogin()
            }
        } catch {
            print("Error parsing token refresh response:", error)
            promptUserToReLogin()
        }
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
