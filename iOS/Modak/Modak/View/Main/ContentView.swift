//
//  ContentView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    
    var body: some View {
        
        // TODO: TabView selection 변수가 필요한지 체크하기
        if #available(iOS 18.0, *) {
            TabView {
                Tab {
                    LogPileView()
                        .toolbarBackground(.backgroundLogPile, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                } label: {
                    Image(.tabLogFile)
                    Text("장작 창고")
                }
                
                Tab {
                    CampfireView()
                        .toolbarBackground(.backgroundLogPile, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                } label: {
                    Image(.tabCampfire)
                    Text("캠프파이어")
                }
                
                Tab {
                    ProfileView()
                        .toolbarBackground(.backgroundLogPile, for: .tabBar)
                        .toolbarBackgroundVisibility(.visible, for: .tabBar)
                } label: {
                    Image(.tabProfile)
                    Text("프로필")
                }
            }
        } else {
            TabView {
                Group {
                    LogPileView()
                        .tabItem {
                            Label("장작 창고", image: .tabLogFile)
                        }
                    
                    CampfireView()
                        .tabItem {
                            Label("캠프파이어", image: .tabCampfire)
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("프로필", image: .tabProfile)
                        }
                }
                .toolbarBackground(.backgroundLogPile, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            }
        }
    }
}

#Preview {
    ContentView()
}
