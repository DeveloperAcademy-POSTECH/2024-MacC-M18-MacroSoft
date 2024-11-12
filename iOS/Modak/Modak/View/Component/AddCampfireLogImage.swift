//
//  AddCampfireLogImage.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI

struct AddCampfireLogImage: View {
    var body: some View {
        Image(.log3D)
            .overlay {
                HStack {
                    Spacer()
                    VStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.init(hex: "F1DCD1"))
                    }
                }
            }
    }
}
