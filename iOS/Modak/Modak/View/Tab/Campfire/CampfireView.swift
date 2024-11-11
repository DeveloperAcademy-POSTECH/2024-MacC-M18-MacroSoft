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
    @Query var campfires: [Campfire]
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        VStack {
            if viewModel.isEmptyCampfire && campfires.isEmpty {
                EmptyCampfireView()
            } else {
                SelectedCampfireView(isShowSideMenu: $isShowSideMenu)
            }
        }
        .background {
            Group {
                Color.backgroundDefault
                LinearGradient.campfireViewBackground
                EllipticalGradient.campfireViewBackground
                    .rotationEffect(.degrees(90), anchor: UnitPoint(x: 0.5, y: 0.75))
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    CampfireView(isShowSideMenu: .constant(false))
}
