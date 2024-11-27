//
//  ExpandedPhoto.swift
//  Modak
//
//  Created by Park Junwoo on 11/4/24.
//

import SwiftUI

struct ExpandedPhoto: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 21, height: 21)
                        .foregroundStyle(.textColorGray1)
                }
                .padding(.trailing, 20)
            }
            Spacer()
            
            // TODO: 선택한 이미지가 보이도록 로직 추가
            if let uiImage = campfireViewModel.mainTodayImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(.photosIcon)
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
        }
    }
}
