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
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
              // 요청 구성 (필요한 범위 설정 등)
              request.requestedScopes = [.fullName, .email]
            },
          onCompletion: { result in
              viewModel.handleAppleSignIn(result: result)
          }
        )
    }
}


#Preview {
    AppleSigninButton()
}
