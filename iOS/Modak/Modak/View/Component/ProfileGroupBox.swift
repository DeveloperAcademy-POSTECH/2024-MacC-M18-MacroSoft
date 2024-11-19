//
//  ProfileViewGroupBox.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct ProfileGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.label
            configuration.content
        }
        .background(ProfileItemFrame())
        .font(Font.custom("Pretendard-regular", size: 16))
        .foregroundStyle(.textColor1)
    }
}

#Preview {
    GroupBox {
        ProfileItem(title: "모닥불 정보", destination: AnyView(EmptyView()))
        ProfileItem(title: "개인정보 처리방침", destination: AnyView(EmptyView()))
        ProfileItem(title: "이용약관", destination: AnyView(EmptyView()))
    }
    .groupBoxStyle(ProfileGroupBox())
}
