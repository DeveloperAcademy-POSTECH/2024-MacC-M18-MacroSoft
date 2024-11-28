//
//  ExpandedPhoto.swift
//  Modak
//
//  Created by Park Junwoo on 11/4/24.
//

import SwiftUI
import Kingfisher

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
            
            if let todayImageURL = campfireViewModel.mainTodayImageURL {
                KFImage(todayImageURL)
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
