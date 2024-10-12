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
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Spacer(minLength: 2)
            Image(systemName: "chevron.backward")
                .aspectRatio(contentMode: .fit)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.textColor1)
        }
    }
}

#Preview {
    BackButton()
}
