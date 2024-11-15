//
//  ProfileViewButton.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct ProfileItem: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    private(set) var title: String
    private let destination: AnyView?
    private let action: (() -> Void)?
    
    init(title: String, destination: AnyView? = nil, action: (() -> Void)? = nil) {
        self.title = title
        self.destination = destination
        self.action = action
    }
    
    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination.environmentObject(viewModel)) {
                    content
                }
            } else {
                Button(action: {
                    action?()
                }) {
                    content
                }
            }
        }
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(title == "회원 탈퇴" ? Color.errorRed : Color.textColor1)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
    
    private var content: some View {
        HStack {
            Text(title)
            Spacer()
            icon
        }
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
    ProfileItem(title: "프로필 정보 편집", destination: AnyView(EmptyView()))
    .background { ProfileItemFrame() }
    ProfileItem(title: "회원 탈퇴", destination: AnyView(EmptyView()))
    .background { ProfileItemFrame() }
}
