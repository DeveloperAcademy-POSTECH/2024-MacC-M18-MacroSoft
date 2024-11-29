//
//  CampfireMainAvatarView.swift
//  Modak
//
//  Created by kimjihee on 11/26/24.
//

import SwiftUI
import SceneKit
import Lottie

struct CampfireMainAvatarView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var avatarViewModel: AvatarViewModel
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(.campfiremainavatarviewTree)
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.main.bounds.width)
                .padding(.top, 180)
            
            // scene 추가
            CustomSCNView(scene: avatarViewModel.scene)
                .edgesIgnoringSafeArea(.all)
                .frame(height: 480)
                .onAppear {
                    Task {
                        avatarViewModel.memberEmotions = (viewModel.mainCampfireInfo?.todayImage.emotions)!
                        guard let memberIds = viewModel.mainCampfireInfo?.memberIds else { return }
                        await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
                    }
                }
                .onChange(of: viewModel.isEmotionRequest) { _, newValue in
                    if newValue {
                        Task {
                            avatarViewModel.memberEmotions = (viewModel.mainCampfireInfo?.todayImage.emotions)!
                            guard let memberIds = viewModel.mainCampfireInfo?.memberIds else { return }
                            await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
                            print("emoji-avatarViewModel : \(avatarViewModel.memberEmotions)")
                            print("emoji-mainCampfireInfo : \(String(describing: viewModel.mainCampfireInfo?.todayImage.emotions))")
                            viewModel.isEmotionRequest = false
                        }
                    }
                }
                .onChange(of: viewModel.mainCampfireInfo) { _, newValue in
                    Task {
                        avatarViewModel.memberEmotions = (viewModel.mainCampfireInfo?.todayImage.emotions)!
                        guard let memberIds = viewModel.mainCampfireInfo?.memberIds else { return }
                        await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
                        print("emoji-avatarViewModel : \(avatarViewModel.memberEmotions)")
                        print("emoji-mainCampfireInfo : \(String(describing: viewModel.mainCampfireInfo?.todayImage.emotions))")
                        viewModel.isEmotionRequest = false
                    }
                }
            
            LottieView(filename: "fireTest")
                .frame(width: UIScreen.main.bounds.width * 2.5)
                .padding(.top, 160)
        }
    }
}

#Preview {
    CampfireMainAvatarView()
}
