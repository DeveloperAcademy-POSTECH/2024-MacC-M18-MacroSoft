//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 10/7/24.
//

import SwiftUI

struct RegisterView: View {
    @State private var currentPage = 0
    private let totalPages = 3
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            VStack {
                Group {
                    Text("소중한 순간,")
                        .foregroundStyle(Color.textColor2)
                    + Text("\n자동으로 모아드릴게요")
                        .foregroundStyle(Color.textColor1)
                }
                .font(.custom("Pretendard-Bold", size: 22))
                .lineSpacing(22 * 0.45)
                .padding(.bottom, 12)
                .padding(.top, 20)
            
                Text("여행, 소풍, 즐거운 순간들,\n시공간에 따른 추억을 하나의 이야기로 모아드려요")
                    .foregroundStyle(Color.textColorGray1)
                    .font(.custom("Pretendard-Regular", size: 16))
                    .lineSpacing(16 * 0.5)
                    .padding(.bottom, 53)
                
                Rectangle()
                    .frame(width: 316, height: 316)
                    .foregroundStyle(Color.black.opacity(0.3))
                    .overlay {
                        Text("추억(장작)을 정리하기\n패기")
                            .font(.custom("Pretendard-Bold", size: 22))
                            .foregroundStyle(Color.textColorGray1)
                            .opacity(0.4)
                    }
                    .padding(.bottom, 65)
                
                PageIndicator(currentPage: currentPage, totalPages: totalPages)
                    .padding(.bottom, 20)
                
                HStack(spacing: 12) {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .frame(width: 11.20, height: 14)
                    Text("Apple로 시작하기")
                }
                .font(.custom("Pretendard-Bold", size: 16))
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                .frame(width: 345, height: 58)
                .background(.white)
                .cornerRadius(76)
                
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    RegisterView()
}
