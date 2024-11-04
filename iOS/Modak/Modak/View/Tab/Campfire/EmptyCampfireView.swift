//
//  EmptyCampfireView.swift
//  Modak
//
//  Created by Park Junwoo on 11/1/24.
//

import SwiftUI

// MARK: - EmptyCampfireView

struct EmptyCampfireView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("참여한 모닥불이 없어요.")
                .foregroundStyle(.textColorGray1)
                .font(Font.custom("Pretendard-Bold", size: 20))
                .padding(.bottom, 8)
            
            Text("친구와 함께 함께 모닥불을 만들거나,\n친구의 모닥불에 초대받아보세요.")
                .foregroundStyle(.textColorGray2)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .lineSpacing(16 * 0.5)
                .multilineTextAlignment(.center)
                .padding(.bottom, 8)
            
            HStack(spacing: 16) {
                EmptyCampfireViewButton(buttonImage: .milestone, buttonText: "모닥불 참여")
                EmptyCampfireViewButton(buttonImage: .tent, buttonText: "모닥불 생성")
            }
            .padding(.horizontal, 38)
            
            Spacer()
        }
    }
}

// MARK: - EmptyCampfireViewButton

private struct EmptyCampfireViewButton: View {
    private(set) var buttonImage: ImageResource
    private(set) var buttonText: String
    var body: some View {
        NavigationLink {
            switch buttonImage {
            case .milestone:
                // TODO: 모닥불 참여뷰 연결
                CampfireNameView(isCreate: false)
            case .tent:
                CampfireNameView(isCreate: true)
            default:
                CampfireNameView(isCreate: true)
            }
        } label: {
            VStack(spacing: 16) {
                Image(buttonImage)
                    .resizable()
                    .scaledToFit()
                
                Text(buttonText)
                    .foregroundStyle(.white)
                    .font(Font.custom("Pretendard-SemiBold", size: 14))
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 26)
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.init(hex: "423C3C"))
                .stroke(Color.init(hex: "4B4B4B"), lineWidth: 1)
        }
    }
}
