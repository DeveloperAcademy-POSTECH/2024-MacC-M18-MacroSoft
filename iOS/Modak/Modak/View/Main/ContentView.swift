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
    @State private var isShowSideMenu: Bool = false
    
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(.backgroundLogPile.opacity(0.73))
        tabBarAppearance.shadowColor = UIColor(.white.opacity(0.15))
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
        NavigationStack() {
            Group {
                if #available(iOS 18.0, *) {
                    TabView(selection: $tabSelection) {
                        Tab(value: 0) {
                            LogPileView()
                        } label: {
                            Image(.tabLogFile)
                            Text("장작 창고")
                        }
                        
                        Tab(value: 1) {
                            CampfireView(isShowSideMenu: $isShowSideMenu)
                        } label: {
                            Image(.tabCampfire)
                            Text("모닥불")
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
                        
                        CampfireView(isShowSideMenu: $isShowSideMenu)
                            .tabItem {
                                Label("모닥불", image: .tabCampfire)
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
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationCustomTitle(tabSelection: tabSelection)
                }
            }
            .modifier(NavigationBarModifier(tabSelection: tabSelection))
            .overlay(alignment: .topLeading) {
                ZStack(alignment: .topLeading) {
                    if isShowSideMenu {
                        Color.black.opacity(0.01)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    isShowSideMenu = false
                                }
                            }
                    }
                    
                    SelectCampfiresView(isShowSideMenu: $isShowSideMenu)
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .background {
                            LinearGradient.SelectCampfiresViewBackground
                                .ignoresSafeArea()
                                .shadow(color: .black.opacity(0.25), radius: 4.9, x: 3, y: 0)
                        }
                        .offset(x: isShowSideMenu ? 0 : -UIScreen.main.bounds.width * 0.9)
                }
            }
        }
    }
}

private struct NavigationCustomTitle: View {
    private(set) var tabSelection: Int
    
    var body: some View {
        Group {
            if tabSelection == 0 {
                Text("내 장작 창고")
            } else if tabSelection == 2 {
                Text("프로필")
            }
        }
        .foregroundStyle(.textColorTitleView)
        .font(Font.custom("Pretendard-SemiBold", size: 17))
        .padding(.leading, 8)
    }
}

private struct NavigationBarModifier: ViewModifier {
    private(set) var tabSelection: Int
    
    func body(content: Content) -> some View {
        if tabSelection == 0 {
            content
                .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        }
        else {
            content
                .toolbarBackground(.hidden, for: .navigationBar)
        }
    }
}

#Preview {
    ContentView()
}
