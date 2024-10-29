//
//  JoinCampfire.swift
//  Modak
//
//  Created by kimjihee on 10/29/24.
//

import SwiftUI

struct JoinCampfire: View {
    @State var roomName:  String = ""
    @State var roomPassword: String = ""
    @State private var isCameraMode: Bool = true
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.backgroundDefault.ignoresSafeArea(.all)
            
            VStack {
                Text("모닥불로 가는 길을 알려주세요")
                    .foregroundStyle(Color.white)
                    .font(.custom("Pretendard-Bold", size: 18))
                    .lineSpacing(18 * 0.45)
                    .padding(EdgeInsets(top: 8, leading: 22, bottom: 0, trailing: 0))
                
                Spacer()
            }
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Image("joincampfire_sign")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width)
                        .overlay {
                            VStack(alignment: .leading, spacing: 14) {
                                HStack {
                                    TextField("", text: $roomName)
                                        .customTextFieldStyle(placeholder: "모닥불 이름", text: $roomName, alignment: .center)
                                    Text("(으)로 가는 길")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 23))
                                        .kerning(23 * 0.01)
                                        .fixedSize(horizontal: true, vertical: false) // 가로 크기 고정
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: 96))
                                
                                HStack {
                                    TextField("", text: $roomPassword)
                                        .customTextFieldStyle(placeholder: "km", text: $roomPassword, alignment: .trailing)
                                    Text("남음")
                                        .foregroundStyle(Color.init(hex: "795945"))
                                        .font(.custom("Pretendard-Bold", size: 23))
                                        .kerning(23 * 0.01)
                                }
                                .padding(EdgeInsets(top: 0, leading: 38, bottom: 0, trailing: 182))
                            }
                            .padding(.top, -98)
                        }
                        .padding(.top, -80)
                    
                    Spacer()
                }
            }
            
            // 모드 선택 토글 버튼
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        isCameraMode.toggle() // 모드 전환
                    }) {
                        Text(isCameraMode ? "촬영해서 입력" : "직접 입력하기")
                            .font(.custom("Pretendard-Regular", size: 16))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 14, leading: 20, bottom: 14, trailing: 20))
                            .background(Color.textBackgroundRedGray.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 100)
                                    .stroke(Color.mainColor1, lineWidth: 1.8) // 라인선 추가
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 100))
                            .animation(.easeInOut, value: isCameraMode)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 14)
            }
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

#Preview {
    NavigationStack {
        JoinCampfire()
    }
}
