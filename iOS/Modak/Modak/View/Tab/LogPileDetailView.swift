//
//  LogPileDetailView.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import SwiftUI

struct LogPileDetailView:View {
    private var gridItems: [GridItem] = Array(repeating: GridItem(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 1.5), count: 3)
    
    var body: some View {
        NavigationStack{
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 1.5) {
                    ForEach(0..<20) { _ in
                        Button {
                            
                        } label: {
                            // TODO: 실제 사진 받아와서 적용시키기
                            Rectangle()
                                .aspectRatio(1, contentMode: .fill)
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .padding(.top, UIScreen.main.bounds.size.width / 5)
            }
            .background(.black)
            .overlay{
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.51), location: 0.81),
                        Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 0.2)
                )
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    VStack(alignment: .leading, spacing: 14) {
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        .padding(.top, 64)
                        HStack(spacing: 10) {
                            // TODO: 이미지 받아서 적용시키기
                            Image(.testPhotosIcon)
                                .padding(.bottom, 5)
                            VStack(alignment: .leading) {
                                HStack {
                                    // TODO: 역지오 코딩 적용
                                    Text("포항시 남구")
                                        .font(
                                            Font.custom("Pretendard-Bold", size: 18)
                                        )
                                        .foregroundStyle(.textColor1)
                                    +
                                    Text("에서의 추억로그")
                                        .font(
                                            Font.custom("Pretendard-regular", size: 18)
                                        )
                                }
                                Text("2024년 10월 12일")
                                    .font(
                                        Font.custom("Pretendard-Medium", size: 14)
                                    )
                                    .opacity(0.8)
                            }
                        }
                    }
                    .foregroundStyle(.textColorGray1)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    LogPileDetailView()
}
