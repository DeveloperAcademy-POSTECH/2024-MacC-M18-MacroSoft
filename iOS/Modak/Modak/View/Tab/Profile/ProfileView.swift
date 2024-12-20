//
//  ProfileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SceneKit

struct ProfileView: View {
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    @AppStorage("isInitialAvatarDataLoad") private var isInitialAvatarDataLoad: Bool = true
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    @State private var showAvatarCustomizingView = false
    @State private var showWebViewSheet = false
    @State private var webViewURL: URL? = nil
    
    var body: some View {
        VStack {
            CustomSCNView(scene: profileViewModel.scene)
                .onAppear {
                    if isInitialAvatarDataLoad {
                        Task {
                            await profileViewModel.fetchUserAvatar()
                            isInitialAvatarDataLoad = false
                        }
                    } else {
                        if let loadedItems = profileViewModel.loadSelectedItems() {
                            profileViewModel.selectedItems = loadedItems
                        }
                        profileViewModel.setupScene()
                    }
                }
                .onChange(of: showAvatarCustomizingView) { _, newValue in
                    if !newValue {
                        if let loadedItems = profileViewModel.loadSelectedItems() {
                            profileViewModel.selectedItems = loadedItems
                            profileViewModel.setupScene()
                        }
                    }
                }
                .padding(.init(top: -100, leading: -70, bottom: -70, trailing: -70))
                .frame(height: 200)
            
            Button(action: {
                showAvatarCustomizingView = true
            }) {
                Text(" 캐릭터 꾸미기 ")
                    .font(.custom("Pretendard-Bold", size: 16))
                    .foregroundColor(.white)
                    .padding(15)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.mainColor1)
                            .stroke(.white.opacity(0.05), lineWidth: 1)
                    }
            }
            .padding(.vertical, 10)
            
            ScrollView {
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
        }
        // TODO: 제거해도 될듯?
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
        .fullScreenCover(isPresented: $showAvatarCustomizingView) {
            AvatarCustomizingView(viewModel: AvatarCustomizingViewModel(sharedItems: profileViewModel.selectedItems))
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
