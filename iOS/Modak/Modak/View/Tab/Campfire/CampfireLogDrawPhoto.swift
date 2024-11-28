//
//  CampfireLogDrawPhoto.swift
//  Modak
//
//  Created by Park Junwoo on 11/26/24.
//

import SwiftUI
import Kingfisher

struct CampfireLogDrawPhoto: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    
    @State private var image: UIImage?
    @State private var imageURL: URL?
    
    var imageName: String
    
    var isClip: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if let url = imageURL {
                if isClip {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipShape(Rectangle())
                        .clipped()
                } else {
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            } else {
                Color.gray
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .onAppear {
                        imageURL = viewModel.getWebpImageDataURL(imageURLName: imageName)
                    }
            }
        }
    }
}
