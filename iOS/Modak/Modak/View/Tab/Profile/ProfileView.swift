//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var showWebViewSheet = false
    @State private var webViewURL: URL? = nil
    
    var body: some View {
        VStack {
            
            Text("닉네임 : \(profileViewModel.originalNickname)")
            
            ProfileItem(title: "프로필 정보 편집", destination: AnyView(EditProfileView()))
            .background { ProfileItemFrame() }
            
            GroupBox {
                ProfileItem(title: "모닥불 정보", destination: AnyView(AppDetailsView()))
                ProfileItem(title: "개인정보 처리방침") {
                    openWebView(url: "https://sites.google.com/view/modak-privacy/%ED%99%88")
                }
                ProfileItem(title: "이용약관") {
                    openWebView(url: "https://sites.google.com/view/modak-servicepolicy/%ED%99%88")
                }
            }
            .groupBoxStyle(ProfileGroupBox())
            
            ProfileItem(title: "로그아웃") {
                profileViewModel.logout { success in
                    if success {
                        isSkipRegister = false
                    }
                }
            }
            .background { ProfileItemFrame() }
            
            Spacer()
        }
        .environmentObject(profileViewModel)
        .padding(.top, 18)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .onAppear() {
            profileViewModel.fetchNickname()
        }
        .sheet(isPresented: Binding(get: { webViewURL != nil && showWebViewSheet }, set: { _ in }), onDismiss: {
            showWebViewSheet = false
        }) {
            if let url = webViewURL {
                ZStack(alignment: . topTrailing) {
                    WebView(url: url)
                        .edgesIgnoringSafeArea(.bottom)
                        .presentationDetents([.large])
                        .presentationCornerRadius(34)
                    
                    Button(action: {
                        showWebViewSheet = false
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color.textColor3)
                            .font(.custom("Pretendard-SemiBold", size: 22))
                    }
                    .padding(EdgeInsets(top: 14, leading: 0, bottom: 0, trailing: 26))
                }
            }
        }
    }
    
    private func openWebView(url: String) {
        webViewURL = URL(string: url)
        showWebViewSheet = true
    }
}

#Preview {
    ProfileView()
}
