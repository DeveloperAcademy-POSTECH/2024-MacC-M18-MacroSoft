//
//  CampfireView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct CampfireView: View {
    // TODO: 참여한 모닥불이 없는지 체크하는 로직 추가
    @State private var isEmptyCampfire: Bool = false
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        VStack {
            // TODO: 참여한 모닥불이 없는지 체크하는 로직 추가
            if isEmptyCampfire {
                EmptyCampfireView()
            } else {
                SelectedCampfireView(isShowSideMenu: $isShowSideMenu)
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
