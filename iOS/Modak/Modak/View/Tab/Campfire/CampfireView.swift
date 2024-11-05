//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct CampfireView: View {
    // TODO: 참여한 모닥불이 없는지 체크하는 로직 추가
    @State private var isEmptyCampfire: Bool = true
    
    var body: some View {
        VStack {
            // TODO: 참여한 모닥불이 없는지 체크하는 로직 추가
            if isEmptyCampfire {
                EmptyCampfireView()
            } else {
                SelectedCampfireView()
            }
        }
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
