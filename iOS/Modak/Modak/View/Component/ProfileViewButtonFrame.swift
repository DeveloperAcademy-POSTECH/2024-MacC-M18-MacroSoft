//
//  ProfileViewButtonFrame.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

// TODO: stroke 색 바꾸기
struct ProfileViewButtonFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20).fill(Color.profileButtonBackground.opacity(0.45)).stroke(.gray, lineWidth: 0.3)
    }
}
