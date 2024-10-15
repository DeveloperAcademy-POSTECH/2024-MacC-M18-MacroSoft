//
//  PhotoView.swift
//  Modak
//
//  Created by Park Junwoo on 10/14/24.
//

import SwiftUI
import Photos

struct PhotoGridView: View {
    private(set) var selectedLog: Log
    private(set) var selectedPhotoMetadata: PhotoMetadata
    @State private var tabSelection: String = ""
    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(selectedLog.images, id: \.id) { metadata in
                VStack {
                    Spacer()
                    PhotoGridViewRowImage(photoMetadata: metadata)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .tag(metadata.localIdentifier)
            }
        }
        .background(.backgroundPhoto)
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            tabSelection = selectedPhotoMetadata.localIdentifier
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .principal) {
                VStack{
                    Text("포항시 남구")
                        .foregroundStyle(.textColorWhite)
                        .font(Font.custom("Pretendard-Regular", size: 13))
                    Text("\(Date().logPileRowTitleDayFormat)")
                        .foregroundStyle(.textColor1)
                        .font(Font.custom("Pretendard-Regular", size: 10))
                }
            }
            // TODO: 하단 사진 Selector 구현하기
            /*
             ToolbarItem(placement: .status) {
             ScrollViewReader { scrView in
             ScrollView(.horizontal) {
             
             LazyHStack(spacing: 0) {
             ForEach(images, id: \.self) { image in
             Image(image)
             .resizable()
             .aspectRatio(contentMode: .fill)
             .frame(width: 34)
             .foregroundStyle(.red)
             .background(.blue)
             .clipShape(Rectangle())
             .padding(.horizontal, selection == image ? 16 : 1.5)
             .onTapGesture {
             selection = image
             // 선택된 이미지로 스크롤
             if let selectedIndex = images.firstIndex(of: image) {
             scrView.scrollTo(image, anchor: .center)
             }
             
             }
             .padding(images.count > images.firstIndex(of: selection)! ? .leading : .trailing, CGFloat(images.count - images.firstIndex(of: selection)!) * 34)
             .id(image)
             }
             
             .onChange(of: selection) { _ , value in
             if let selectedIndex = images.firstIndex(of: value) {
             scrView.scrollTo(images[selectedIndex], anchor: .center)
             }
             }
             }
             
             }
             .scrollIndicators(.hidden)
             }
             }
             */
        }
    }
}

// MARK: - PhotoViewRowImage

private struct PhotoGridViewRowImage: View {
    let photoMetadata: PhotoMetadata
    @State private var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
        } else {
            Color.gray
                .onAppear {
                    fetchImage(for: photoMetadata)
                }
        }
    }
    
    private func fetchImage(for metadata: PhotoMetadata) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [metadata.localIdentifier], options: nil)
        
        guard let asset = fetchResult.firstObject else {
            return
        }
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width), contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

//#Preview {
//    PhotoGridView(selectedPicture: .constant(0))
//}
