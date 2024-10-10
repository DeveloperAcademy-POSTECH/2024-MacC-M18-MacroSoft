//
//  BackButton.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()  // 현재 화면 닫기
        }) {
            Spacer(minLength: 2)
            Image(systemName: "chevron.backward")
                .aspectRatio(contentMode: .fit)
                .font(.system(size: 16, weight: .semibold)) //피그마 설정이랑 다름. 시각적으로 비슷해보이기 위해 조정함.
                .foregroundColor(.textColor1)
        }
    }
}

#Preview {
    BackButton()
}
