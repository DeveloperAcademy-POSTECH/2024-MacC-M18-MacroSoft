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
    @StateObject private var viewModel = AppleSigninViewModel()
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
              // 요청 구성 (필요한 범위 설정 등)
              request.requestedScopes = [.fullName, .email]
            },
          onCompletion: { result in
              viewModel.handleAppleSignIn(result: result)
              // 로그인 성공 시 RegisterView를 넘어가도록 설정
              if viewModel.isLoggedIn {  // 로그인 성공 여부 체크 (isLoggedIn은 AppleSigninViewModel 내에 구현 필요)
                  isSkipRegister = true
              }
          }
        )
    }
}


#Preview {
    AppleSigninButton()
}
