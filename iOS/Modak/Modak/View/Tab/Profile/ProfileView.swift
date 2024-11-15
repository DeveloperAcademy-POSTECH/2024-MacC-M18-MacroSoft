//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            
            Text("닉네임 : \(viewModel.originalNickname)")
            
            ProfileItem(title: "프로필 정보 편집", destination: AnyView(EditProfileView()))
            .background { ProfileItemFrame() }
            
            GroupBox {
                ProfileItem(title: "모닥불 정보", destination: AnyView(AppDetailsView()))
                ProfileItem(title: "개인정보 처리방침") { }
                ProfileItem(title: "이용약관") { }
            }
            .groupBoxStyle(ProfileGroupBox())
            
            ProfileItem(title: "로그아웃", action: { })
            .background { ProfileItemFrame() }
            
            Spacer()
        }
        .environmentObject(viewModel)
        .padding(.top, 18)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .onAppear() {
            viewModel.fetchNickname()
        }
    }
}

#Preview {
    ProfileView()
}
