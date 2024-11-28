//
//  AppDetails.swift
//  Modak
//
//  Created by kimjihee on 11/14/24.
//

import SwiftUI

struct AppDetailsView: View {
    var body: some View {
        VStack {
            HStack {
                Text("서비스 버전")
                    .foregroundStyle(Color.textColor1)
                Spacer()
                Text(Bundle.getAppVersion())
                    .foregroundStyle(Color.textColorGray1)
            }
            .font(Font.custom("Pretendard-regular", size: 16))
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background { ProfileItemFrame() }
            
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 13)
        .background {
            ProfileBackground()
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    BackButton()
                        .colorMultiply(Color.textColorGray1)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppDetailsView()
    }
}
