//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SwiftData

struct CampfireView: View {
    @StateObject private var viewModel = CampfireViewModel()
    @Query var campfires: [Campfire]
    
    var body: some View {
        VStack {
            if viewModel.isEmptyCampfire || campfires.isEmpty {
                EmptyCampfireView()
            } else {
                SelectedCampfireView()
            }
        }
        .environmentObject(viewModel)
        .background {
            Color.backgroundDefault.ignoresSafeArea()
            LinearGradient.campfireViewBackground.ignoresSafeArea()
            EllipticalGradient.campfireViewBackground.rotationEffect(.degrees(90), anchor: UnitPoint(x: 0.5, y: 0.75))
                .ignoresSafeArea()
        }
    }
}

#Preview {
    CampfireView()
}
