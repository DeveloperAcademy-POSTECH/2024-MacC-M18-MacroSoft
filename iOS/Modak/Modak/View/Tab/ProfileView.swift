//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            ProfileViewButton(title: "프로필 정보 편집") {
                // TODO: 프로필 정보 편집 네비게이션
            }
            .background {
                ProfileViewButtonFrame()
            }
            
            GroupBox {
                ProfileViewButton(title: "모닥불 정보") {
                    // TODO: 모닥불 정보 네비게이션
                }
                
                ProfileViewButton(title: "버전 정보") {
                    // TODO: 버전 정보 네비게이션
                }
                ProfileViewButton(title: "개인정보 처리방침") {
                    // TODO: 개인정보 처리방침 네비게이션
                }
                ProfileViewButton(title: "이용약관") {
                    // TODO: 이용약관 네비게이션
                }
            }
            .groupBoxStyle(ProfileViewGroupBox())
            
            ProfileViewButton(title: "로그아웃") {
                // TODO: 로그아웃 네비게이션
            }
            .background {
                ProfileViewButtonFrame()
            }
            Spacer()
        }
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(.textColor1)
        .padding(.top, 18)
        .padding(.horizontal, 13)
        .background(LinearGradient.profileViewBackground)
        .background(Color.backgroundLogPile)
    }
}

private struct ProfileViewButton: View {
    private(set) var title: String
    private(set) var function: () -> Void
    var body: some View {
        Button {
            function()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
}

// TODO: stroke 색 바꾸기
private struct ProfileViewButtonFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20).fill(Color.profileButtonBackground.opacity(0.45)).stroke(.gray, lineWidth: 0.3)
    }
}

private struct ProfileViewGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .background(ProfileViewButtonFrame())
    }
}

#Preview {
    ProfileView()
}
