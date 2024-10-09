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
                Image("Test_PagingBar1")
                    .padding(.top, -12)
                
                onboardingView(
                    title: "잊어버린 사진 속 순간들을\n추억으로 정리해요",
                    titleHighlightRanges: [5...11, 15...16],
                    context: "추억을 만나기 위해 다음 권한이 필요해요",
                    image: "null"
                )
                
                Spacer()
                
                Button(action: {
                    // 동작 추가 필요
                }) {
                    RoundedRectangle(cornerRadius: 73)
                        .frame(width: 345, height: 58)
                        .foregroundStyle(Color.mainColor1)
                        .overlay {
                            Text("동의하고 정리 시작하기")
                                .font(.custom("Pretendard-Bold", size: 17))
                                .lineSpacing(14 * 0.4)
                                .foregroundStyle(Color.white)
                        }
                }
                .padding(.bottom, 14)
            }
            
            VStack {
                Image("Test_PhotosIcon")
                    .padding(.bottom, 20)
                
                Text("카메라•사진첩")
                    .foregroundStyle(Color.white)
                    .font(.custom("Pretendard-SemiBold", size: 17))
                    .padding(.bottom, 10)
                
                Text("추억이 담긴 사진을 정리하고 확인할 수 있어요")
                    .foregroundStyle(Color.textColorGray1)
                    .font(.custom("Pretendard-Regular", size: 15))
                    .padding(.bottom, 8)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 326, height: 56)
                    .foregroundStyle(Color.textBackgroundRedGray.opacity(0.1))
                    .overlay {
                        Text("사진은 휴대전화 내에서만 사용됩니다\n관련한 정보는 개발자가 접근할 수 없어요.")
                            .font(.custom("Pretendard-Regular", size: 14))
                            .lineSpacing(14 * 0.4)
                            .foregroundStyle(Color.textColorGray2)
                    }
            }
            .padding(.bottom, 80)
            
            
        }
        .multilineTextAlignment(.center)
        .navigationBarBackButtonHidden(true)  // 기본 네비게이션 백 버튼 숨기기
        .navigationBarItems(leading: BackButton())  // 커스텀 백 버튼 추가
    }
}

#Preview {
    AuthorizationView()
}
