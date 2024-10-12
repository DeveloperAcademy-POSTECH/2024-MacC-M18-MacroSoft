//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
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
            // TODO: LinearGradient extension 파일에 합치기
            .background(LinearGradient(
                stops: [
                    Gradient.Stop(color: Color.init(hex: "FFC5A0").opacity(0.09), location: 0.00),
                    Gradient.Stop(color: Color.init(hex: "FFEEA0").opacity(0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: -0.07),
                endPoint: UnitPoint(x: 0.5, y: 0.37)
            ))
            .background(Color.backgroundLogPile)
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    ProfileViewTitle()
                }
            }
        }
    }
}

private struct ProfileViewTitle: View {
    var body: some View {
        Text("프로필")
            .foregroundStyle(.textColorTitleView)
            .font(Font.custom("Pretendard-SemiBold", size: 17))
            .padding(.leading, 8)
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
