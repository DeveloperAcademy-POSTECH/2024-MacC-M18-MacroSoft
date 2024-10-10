//
//  ContentView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    @State private var tabSelection: Int = 0
    
    init () {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .backgroundLogPile
        tabBarAppearance.shadowColor = UIColor(.white.opacity(0.15))
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some View {
        
        if #available(iOS 18.0, *) {
            TabView(selection: $tabSelection) {
                Tab(value: 0) {
                    LogPileView()
                } label: {
                    Image(.tabLogFile)
                    Text("장작 창고")
                }
                
                Tab(value: 1) {
                    CampfireView()
                } label: {
                    Image(.tabCampfire)
                    Text("캠프파이어")
                }
                
                Tab(value: 2) {
                    ProfileView()
                } label: {
                    Image(.tabProfile)
                    Text("프로필")
                }
            }
        } else {
            TabView(selection: $tabSelection) {
                LogPileView()
                    .tabItem {
                        Label("장작 창고", image: .tabLogFile)
                    }
                    .tag(0)
                
                CampfireView()
                    .tabItem {
                        Label("캠프파이어", image: .tabCampfire)
                    }
                    .tag(1)
                
                ProfileView()
                    .tabItem {
                        Label("프로필", image: .tabProfile)
                    }
                    .tag(2)
            }
        }
    }
}

#Preview {
    ContentView()
}
