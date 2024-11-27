//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics

struct CampfireView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var avatarViewModel: AvatarViewModel
    @Query var campfires: [Campfire]
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        // VStack {
        //    if viewModel.myCampfireInfos.isEmpty {
        ZStack {
            if viewModel.myCampfireInfos.isEmpty && campfires.isEmpty {
                EmptyCampfireView()
            } else {
                SelectedCampfireView(isShowSideMenu: $isShowSideMenu)
            }
        }
        .onAppear {
            Task {
                guard let memberIds = viewModel.mainCampfireInfo?.memberIds else { return }
                await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
            }
        }
        .onChange(of: viewModel.mainCampfireInfo) { _, newValue in
            Task {
                guard let memberIds = viewModel.mainCampfireInfo?.memberIds else { return }
                await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
            }
        }
        .background {
            CampfireBackground()
                .ignoresSafeArea()
        }
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "CampfiresView",
                AnalyticsParameterScreenClass: "CampfiresView"])
        }
    }
}

#Preview {
    CampfireView(isShowSideMenu: .constant(false))
}
