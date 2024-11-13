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
            
            ProfileViewButton(title: "프로필 정보 편집", destination: EditProfileView())
            .background { ProfileViewButtonFrame() }
            
            GroupBox {
                ProfileViewButton(title: "모닥불 정보", destination: EmptyView())
                ProfileViewButton(title: "개인정보 처리방침", destination: EmptyView())
                ProfileViewButton(title: "이용약관", destination: EmptyView())
            }
            .groupBoxStyle(ProfileViewGroupBox())
            
            ProfileViewButton(title: "로그아웃", destination: EmptyView())
            .background { ProfileViewButtonFrame() }
            
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
