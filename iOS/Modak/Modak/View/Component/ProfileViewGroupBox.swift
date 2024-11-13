//
//  ProfileViewGroupBox.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct ProfileViewGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .background(ProfileViewButtonFrame())
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(.textColor1)
    }
}

#Preview {
    GroupBox {
        ProfileViewButton(title: "모닥불 정보") {

        }
        ProfileViewButton(title: "개인정보 처리방침") {

        }
        ProfileViewButton(title: "이용약관") {

        }
    }
    .groupBoxStyle(ProfileViewGroupBox())
}
