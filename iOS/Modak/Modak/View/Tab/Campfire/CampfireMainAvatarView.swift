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
                .frame(height: 480)
            
            LottieView(filename: "fireTest")
                .frame(width: UIScreen.main.bounds.width * 2.5)
                .padding(.top, 160)
        }
    }
}

#Preview {
    CampfireMainAvatarView()
}
