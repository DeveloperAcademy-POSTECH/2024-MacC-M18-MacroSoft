//
//  ProfileViewButton.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct ProfileViewButton<Destination: View>: View {
    private(set) var title: String
    private(set) var destination: Destination?
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack {
                Text(title)
                Spacer()
                icon
            }
        }
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(title == "회원 탈퇴" ? Color.errorRed : Color.textColor1)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
    
    private var icon: some View {
        switch title {
        case "프로필 정보 편집", "모닥불 정보", "닉네임 변경":
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textColorGray1)
        case "개인정보 처리방침", "이용약관":
            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(Color.textColor1)
        case "로그아웃", "회원 탈퇴":
            Image(systemName: "rectangle.portrait.and.arrow.forward")
                .foregroundStyle(Color.errorRed)
        default:
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.textColorGray1)
        }
    }
}

#Preview {
    ProfileViewButton(title: "프로필 정보 편집", destination: EmptyView())
    .background { ProfileViewButtonFrame() }
    ProfileViewButton(title: "회원 탈퇴", destination: EmptyView())
    .background { ProfileViewButtonFrame() }
}
