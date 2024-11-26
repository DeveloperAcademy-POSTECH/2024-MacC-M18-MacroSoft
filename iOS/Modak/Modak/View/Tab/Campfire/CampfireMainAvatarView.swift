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
            // scene 추가
            CustomSCNView(scene: avatarViewModel.scene)
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    Task {
                        guard let memberIds = viewModel.campfire?.memberIds else { return }
                        await fetchMemberAvatars(memberIds: memberIds)
                    }
                }
                .onChange(of: viewModel.recentVisitedCampfirePin) { _, newValue in
                    Task {
                        guard let memberIds = viewModel.campfire?.memberIds else { return }
                        await fetchMemberAvatars(memberIds: memberIds)
                    }
                }
                .frame(height: 480)
            
            LottieView(filename: "fireTest")
                .frame(width: 500, height: 500)
                .padding(.top, 160)
        }
    }
    
    private func fetchMemberAvatars(memberIds: [Int]) async {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMembersNicknameAvatar(memberIds: memberIds))
                let decoder = JSONDecoder()
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let resultArray = jsonResponse["result"] as? [[String: Any]] {
                    let jsonData = try JSONSerialization.data(withJSONObject: resultArray, options: [])
                    let fetchedAvatars = try decoder.decode([MemberAvatar].self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.avatarViewModel.memberAvatars = fetchedAvatars
                        print(">>> fetchedAvatars :\(fetchedAvatars)")
                        avatarViewModel.avatar = AvatarData.sample2
                        avatarViewModel.setupScene2()
                    }
                } else {
                    print("Unexpected API response structure.")
                }
            } catch {
                print("Error fetching member avatars: \(error)")
            }
        }
    }
}

#Preview {
    CampfireMainAvatarView()
}
