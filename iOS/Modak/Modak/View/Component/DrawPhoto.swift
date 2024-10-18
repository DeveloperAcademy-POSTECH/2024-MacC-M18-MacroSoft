//
//  DrawPhoto.swift
//  Modak
//
//  Created by Park Junwoo on 10/16/24.
//

import SwiftUI
import Photos

struct DrawPhoto: View {
    @State private var image: UIImage?
    
    let photoMetadata: PhotoMetadata
    var isClip: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            if let image = image {
                if isClip {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                        .clipShape(Rectangle())
                        .clipped()
                } else {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width)
                }
            } else {
                Color.gray
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .onAppear {
                        fetchImage(for: photoMetadata, size: geometry.size)
                    }
            }
        }
    }
    
    private func fetchImage(for metadata: PhotoMetadata, size: CGSize) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [metadata.localIdentifier], options: nil)
        let geometrySize : CGSize = size
        
        guard let asset = fetchResult.firstObject else {
            return
        }
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: geometrySize.width, height: geometrySize.width), contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
