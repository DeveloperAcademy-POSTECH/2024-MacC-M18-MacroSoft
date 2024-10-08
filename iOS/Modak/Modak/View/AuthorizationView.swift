//
//  Authorization.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI

struct AuthorizationView: View {
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            VStack {
                onboardingView(
                    title: "잊어버린 사진 속 순간들을\n추억으로 정리해요",
                    titleHighlightRanges: [5...11, 15...16],
                    context: "추억을 만나기 위해 다음 권한이 필요해요",
                    image: "null"
                )
                
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    AuthorizationView()
}
