//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 10/7/24.
//

import SwiftUI

struct RegisterView: View {
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    private let totalPages = 3
    @State private var currentPage = 0
    
    init() {
        // 페이지 인디케이터 색깔 설정
        UIPageControl.appearance().currentPageIndicatorTintColor = .pagenationAble
        UIPageControl.appearance().pageIndicatorTintColor = .pagenationDisable
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            VStack {
                TabView(selection: $currentPage) {
                    onboardingCard(
                        title: "소중한 순간,\n자동으로 모아드릴게요",
                        titleHighlightRanges: [0...7],
                        context: "여행, 소풍, 즐거운 순간들.\n추억을 하나의 이야기로 모아드려요",
                        image: "onboarding_image1",
                        imagePadding: 0
                    ).tag(0)
                    onboardingCard(
                        title: "추억의 순간 속 사람들과\n모닥불에서 모이세요",
                        titleHighlightRanges: [14...16],
                        context: "함께한 사람들과 그룹을 만들고 추억을 모아보세요\n잊혀진 순간도 모닥불이 찾아드릴게요",
                        image: "onboarding_image2",
                        imagePadding: 0
                    ).tag(1)
                    onboardingCard(
                        title: "같이 만든 추억을\n함께 나누세요",
                        titleHighlightRanges: [9...16],
                        context: "추억으로 피워낸 모닥불 앞에 모여 함께 감상하세요\n",
                        image: "onboarding_image3",
                        imagePadding: 0
                    ).tag(2)
                }
                .padding(.top, 58)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Spacer(minLength: 0)
                
                AppleSigninButton(isSkipRegister: $isSkipRegister)
                
                Button(action: {
                    isSkipRegister = true
                }) {
                    Text("건너뛰기")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.mainColor1)
                        .underline()
                }
                .padding(.top, 14)
                
                Spacer(minLength: 5)
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    RegisterView()
}
