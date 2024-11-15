//
//  SwiftUIView.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    @State private var showDeactivationAlert = false

    var body: some View {
        VStack {
            ProfileItem(title: "닉네임 변경", destination: AnyView(EditNicknameView()))
            .background { ProfileItemFrame() }
            ProfileItem(title: "회원 탈퇴") {
                showDeactivationAlert.toggle()
            }
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
        .alert(isPresented: $showDeactivationAlert) {
            Alert(
                title: Text("회원 탈퇴"),
                message: Text("정말 회원 탈퇴를 진행하시겠습니까?"),
                primaryButton: .destructive(Text("탈퇴")) {
                    viewModel.deactivate { success in
                        if success {
                            isSkipRegister = false
                        } else {
                            print("탈퇴 실패")
                        }
                    }
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView()
    }
}
