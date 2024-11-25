//
//  ProfileBackground.swift
//  Modak
//
//  Created by Park Junwoo on 11/8/24.
//

import SwiftUI

struct ProfileBackground: View {
    var body: some View {
        ZStack {
            Color.backgroundLogPile
            LinearGradient.profileViewBackground
        }
        .edgesIgnoringSafeArea(.all)
    }
}
