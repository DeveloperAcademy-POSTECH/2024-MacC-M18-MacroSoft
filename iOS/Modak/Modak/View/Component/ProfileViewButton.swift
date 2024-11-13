//
//  ProfileViewButton.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct ProfileViewButton: View {
    private(set) var title: String
    private(set) var function: () -> Void
    
    var body: some View {
        Button {
            function()
        } label: {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
            }
        }
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(.textColor1)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
}

#Preview {
    ProfileViewButton(title: "프로필 정보 편집") {
        
    }
}
