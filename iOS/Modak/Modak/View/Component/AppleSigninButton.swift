//
//  AppleSigninButton.swift
//  Modak
//
//  Created by kimjihee on 10/15/24.
//

import SwiftUI
import AuthenticationServices
import CryptoKit

struct AppleSigninButton: View {
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
              // 요청 구성 (필요한 범위 설정 등)
              request.requestedScopes = [.fullName, .email]
            },
          onCompletion: { result in
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
                                        
                    default:
                        break
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("error")
            }
          }
        )
    }
}

#Preview {
    AppleSigninButton()
}
