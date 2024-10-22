//
//  SelectedPhotoView.swift
//  Modak
//
//  Created by Park Junwoo on 10/14/24.
//

import SwiftUI
import Photos
import Firebase

struct SelectedPhotoView: View {
    private(set) var selectedLog: Log
    private(set) var selectedPhotoMetadata: PhotoMetadata
    @State private var tabSelection: String = ""
    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(selectedLog.images, id: \.id) { metadata in
                VStack {
                    Spacer()
                    DrawPhoto(photoMetadata: metadata, isClip: false)
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
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "SelectedPhotoView",
                AnalyticsParameterScreenClass: "SelectedPhotoView"])
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .principal) {
                VStack{
                    Text(selectedLog.address == "위치 정보 없음" ? "지구" : selectedLog.address ?? "지구")
                        .foregroundStyle(.textColorWhite)
                        .font(Font.custom("Pretendard-Regular", size: 13))
                    // 혹시 몰라서 현재 보여지는 사진의 날짜를 가지고 오기는 하는데,,, 현재 로직 상 한 로그는 같은 날짜일거라서...흠
                    if let currentImage = selectedLog.images.first(where: { $0.localIdentifier == tabSelection }) {
                        Text(currentImage.creationDate?.logPileRowTitleDayFormat ?? Date().logPileRowTitleDayFormat)
                            .foregroundStyle(.textColor1)
                            .font(Font.custom("Pretendard-Regular", size: 10))
                    }
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

//#Preview {
//    SelectedPhotoView(selectedPicture: .constant(0))
//}
