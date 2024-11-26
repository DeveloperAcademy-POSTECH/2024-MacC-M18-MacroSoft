//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SwiftData

struct CampfireView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var avatarViewModel: AvatarViewModel
    @Query var campfires: [Campfire]
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View { 
        ZStack {
            if viewModel.isEmptyCampfire && campfires.isEmpty {
                EmptyCampfireView()
            } else {
                SelectedCampfireView(isShowSideMenu: $isShowSideMenu)
            }
        }
        .onAppear {
            Task {
                guard let memberIds = viewModel.campfire?.memberIds else { return }
                await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
            }
        }
        .onChange(of: viewModel.campfire) { _, newValue in
            Task {
                guard let memberIds = viewModel.campfire?.memberIds else { return }
                await avatarViewModel.fetchMemberAvatars(memberIds: memberIds)
            }
        }
        .background {
            CampfireBackground()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CampfireView(isShowSideMenu: .constant(false))
}
