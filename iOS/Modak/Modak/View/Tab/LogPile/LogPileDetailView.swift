//
//  LogPileDetailView.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import SwiftUI
import Photos

struct LogPileDetailView:View {
    private(set) var selectedLog: Log
    
    var body: some View {
        ScrollView {
            LogPileDetailViewGrid(selectedLog: selectedLog)
            // TODO: 현재 Figma의 패딩과 다름
                .padding(.top, UIScreen.main.bounds.size.width / 5)
        }
        .background(.black)
        .overlay{
            LinearGradient.logPileDetailViewBackground
                .ignoresSafeArea(.all)
                .allowsHitTesting(false)
        }
        .overlay {
            LogPileDetailViewTitle(selectedLog: selectedLog)
                .padding(.leading, 20)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                VStack(alignment: .leading, spacing: 14) {
                    BackButton()
                }
                .foregroundStyle(.textColorGray1)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
}

private struct LogPileDetailViewTitle: View {
    private(set) var selectedLog: Log
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(.log3D)
                .aspectRatio(1, contentMode: .fill)
            VStack(alignment: .leading) {
                HStack {
                    Text(selectedLog.address == "위치 정보 없음" ? "지구" : selectedLog.address ?? "지구")
                        .font(
                            Font.custom("Pretendard-Bold", size: 18)
                        )
                        .foregroundStyle(.textColor1)
                    +
                    Text("에서의 추억로그")
                        .font(
                            Font.custom("Pretendard-regular", size: 18)
                        )
                }
                Text(selectedLog.endAt.YYYYMdFormat)
                    .font(
                        Font.custom("Pretendard-Medium", size: 14)
                    )
                    .opacity(0.8)
                Spacer()
            }
            Spacer()
        }
        .foregroundStyle(.textColorGray1)
    }
}

// MARK: - LogPileDetailViewGrid

private struct LogPileDetailViewGrid: View {
    private(set) var selectedLog: Log
    
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 1.5), count: 3)
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1.5) {
            ForEach(selectedLog.images, id: \.id) { metadata in
                // 원래 여기서 @Bindable로 PhotoGridView에 metadata를 넘겨줬었는데 그랬더니 데이터가 엉켜서 같은 사진만 2장 보이는 경우가 생김
                NavigationLink {
                    SelectedPhotoView(selectedLog: selectedLog, selectedPhotoMetadata: metadata)
                } label: {
                    // TODO: 실제 사진 받아와서 적용시키기
                    LogPileDetailViewImage(photoMetadata: metadata)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
}

// MARK: - LogPileViewRowImage

private struct LogPileDetailViewImage: View {
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
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.size.width / 3, height: UIScreen.main.bounds.size.width / 3), contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

//#Preview {
//    LogPileDetailView()
//}