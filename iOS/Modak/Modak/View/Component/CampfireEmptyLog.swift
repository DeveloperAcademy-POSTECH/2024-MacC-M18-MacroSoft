//
//  CampfireEmptyLog.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI

struct CampfireEmptyLog: View {
    private(set) var campfireName: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("추억 장작이 필요해요")
                .foregroundStyle(.textColorGray1)
                .font(Font.custom("Pretendard-Bold", size: 20))
                .padding(.bottom, 8)
            
            Text("\(campfireName) 모닥불에 추억 장작을 넣어\n오늘의 사진을 확인해보세요")
                .foregroundStyle(.textColorGray2)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .padding(.bottom, 22)
                .lineSpacing(16 * 0.5)
                .multilineTextAlignment(.center)
            
            // TODO: 내 추억 장작 개수가 1개 미만인 경우 disable 시키는 로직 추가
            NavigationLink {
                // TODO: 화면 전환 로직 추가
                
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    
                    AddCampfireLogImage()
                    
                    Text("모닥불에 장작 넣기")
                        .foregroundStyle(.white)
                        .font(Font.custom("Pretendard-Bold", size: 16))
                    
                    Spacer()
                }
                .padding(.vertical, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.init(hex: "4C4545"))
                    .stroke(Color.disable, lineWidth: 1)
            }
            .padding(.horizontal, 70)
            
            Spacer()
        }
    }
}
