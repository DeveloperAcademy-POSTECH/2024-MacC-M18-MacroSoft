//
//  CircularProgressPhoto.swift
//  Modak
//
//  Created by kimjihee on 10/9/24.
//

import SwiftUI

struct CircularProgressPhoto: View {
    var body: some View {
        Image("Test_ProgressPhoto")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 213, height: 213)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProgressPhoto()
}
