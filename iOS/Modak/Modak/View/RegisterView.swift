//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 10/7/24.
//

import SwiftUI

struct RegisterView: View {
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
                    onboardingView(
                        title: "소중한 순간,\n자동으로 모아드릴게요",
                        titleHighlightRange: 0...7,
                        context: "여행, 소풍, 즐거운 순간들,\n시공간에 따른 추억을 하나의 이야기로 모아드려요",
                        image: "추억(장작)을 정리하기\n패기"
                    ).tag(0)
                    onboardingView(
                        title: "추억의 순간 속 사람들과\n모닥불에서 모이세요",
                        titleHighlightRange: 14...16,
                        context: "함께한 사람들과 그룹을 만들고 추억을 모아보세요\n잊혀진 순간이 있더라도 모닥불이 찾아드릴게요",
                        image: "추억을 장작 삼아서 불지피기"
                    ).tag(1)
                    onboardingView(
                        title: "같이 만든 추억을\n함께 나누세요",
                        titleHighlightRange: 9...16,
                        context: "추억으로 피워낸 모닥불 앞에 모여 함께 감상하세요\n",
                        image: "다같이 캠프파이어 즐기는 모습"
                    ).tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Spacer(minLength: 0)
                
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .frame(width: 11.20, height: 14)
                    Text("Apple로 시작하기")
                }
                .font(.custom("Pretendard-Bold", size: 16))
                .frame(width: 345, height: 58)
                .background(.white)
                .cornerRadius(76)
                
                Button(action: {
                    // 동작 추가 필요
                }) {
                    Text("건너뛰기")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.mainColor1)
                        .underline()
                }
                .padding(.top, 14)
                
                Spacer(minLength: 12)
            }
            .multilineTextAlignment(.center)
        }
    }
    
    private func onboardingView(title: String, titleHighlightRange: ClosedRange<Int>, context: String, image: String) -> some View {
        var highlightedText = Text("")
        
        for (index, character) in title.enumerated() {
            let currentCharacter = String(character)
            if titleHighlightRange.contains(index) {
                highlightedText = highlightedText + Text(currentCharacter).foregroundStyle(Color.textColor2)
            } else {
                highlightedText = highlightedText + Text(currentCharacter).foregroundStyle(Color.textColor1)
            }
        }
    
        return VStack {
            highlightedText
                .font(.custom("Pretendard-Bold", size: 22))
                .lineSpacing(22 * 0.45)
                .padding(.top, 68)
                .padding(.bottom, 12)
            
            Text(context)
                .foregroundStyle(Color.textColorGray1)
                .font(.custom("Pretendard-Regular", size: 16))
                .lineSpacing(16 * 0.5)
                .padding(.bottom, 50)
            
            Rectangle()
                .frame(width: 316, height: 316)
                .foregroundStyle(Color.black.opacity(0.3))
                .overlay {
                    Text(image)
                        .font(.custom("Pretendard-Bold", size: 22))
                        .foregroundStyle(Color.textColorGray1)
                        .opacity(0.4)
                }
                
            Spacer()
        }
    }
}

#Preview {
    RegisterView()
}
