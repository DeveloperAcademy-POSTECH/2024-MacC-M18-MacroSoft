//
//  ContentView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct ContentView: View {
    @State var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection) {
            LogDetailView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("추억로그")
                }
                .tag(0)
            
            CampfiresView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .tag(1)
                    
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .onAppear {
            selection = 0
        }
    }
}

#Preview {
    ContentView()
}
