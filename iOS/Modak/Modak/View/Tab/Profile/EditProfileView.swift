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
            ProfileViewButton(title: "닉네임 변경", destination: EmptyView())
            .background { ProfileViewButtonFrame() }
            ProfileViewButton(title: "회원 탈퇴", destination: EmptyView())
            .background { ProfileViewButtonFrame() }
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
