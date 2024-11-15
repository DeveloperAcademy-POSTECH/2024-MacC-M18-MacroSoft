//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack {
            ProfileItem(title: "닉네임 변경", destination: AnyView(EditNicknameView()))
            .background { ProfileItemFrame() }
            ProfileItem(title: "회원 탈퇴", destination: AnyView(EmptyView()))
            .background { ProfileItemFrame() }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    BackButton()
                        .colorMultiply(Color.textColorGray1)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
