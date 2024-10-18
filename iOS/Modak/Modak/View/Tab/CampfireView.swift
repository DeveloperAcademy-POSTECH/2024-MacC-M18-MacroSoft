//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct CampfireView: View {
    // TODO: 캠프파이어 임시뷰
    var body: some View {
        ZStack {
            Color.backgroundLogPile.ignoresSafeArea()
            LinearGradient.profileViewBackground.ignoresSafeArea()
            
            VStack(spacing: 8) {
                Spacer()
                Text("캠핑장이 곧 개장할 예정이에요")
                    .foregroundStyle(.textColorGray1)
                    .font(
                        Font.custom("Pretendard-Bold", size: 22)
                    )
                Text("안전하게 마무리될 때까지 기다려주세요")
                    .foregroundStyle(.textColorGray2)
                    .font(
                        Font.custom("Pretendard-Regular", size: 16)
                    )
                
                Spacer()
            }
        }
    }
}

#Preview {
    CampfireView()
}
