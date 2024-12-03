//
//  CampfireLogPileDetailView.swift
//  Modak
//
//  Created by Park Junwoo on 11/26/24.
//

import SwiftUI

struct CampfireLogPileDetailView: View {
    private(set) var selectedLog: LogOverview
    
    var body: some View {
        ScrollView {
            CampfireLogPileDetailViewGrid(selectedLog: selectedLog)
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
            CampfireLogPileDetailViewTitle(selectedLog: selectedLog)
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

private struct CampfireLogPileDetailViewTitle: View {
    private(set) var selectedLog: LogOverview
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(.log3D)
                .aspectRatio(1, contentMode: .fill)
            VStack(alignment: .leading) {
                HStack {
                    Text(selectedLog.address)
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
                Text(selectedLog.startAt.iso8601ToDate.YYYYMdFormat)
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

private struct CampfireLogPileDetailViewGrid: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    
    private(set) var selectedLog: LogOverview
    
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.fixed(UIScreen.main.bounds.size.width / 3), spacing: 1.5), count: 3)
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1.5) {
            ForEach(viewModel.currentCampfireLogImagesData.images, id: \.imageId) { imageData in
                // 원래 여기서 @Bindable로 PhotoGridView에 metadata를 넘겨줬었는데 그랬더니 데이터가 엉켜서 같은 사진만 2장 보이는 경우가 생김
                NavigationLink {
                    CampfireSelectedPhotoView(selectedLog: selectedLog, imageName: imageData.imageName)
                } label: {
                    CampfireLogDrawPhoto(imageName: imageData.imageName, isClip: true)
                        .aspectRatio(1, contentMode: .fill)
                        .foregroundStyle(.accent)
                }
                .onAppear {
                    if imageData.imageId == viewModel.currentCampfireLogImagesData.images.last?.imageId {
                        viewModel.getMoreCampfireLogImages(logId: selectedLog.logId)
                    }
                }
                .simultaneousGesture(TapGesture().onEnded({
                    Task {
                        await viewModel.getCampfireLogImageDetail(imageId: imageData.imageId)
                    }
                }))
            }
        }
    }
}

private struct CampfireSelectedPhotoView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    
    private(set) var selectedLog: LogOverview
    private(set) var imageName: String
    
    @State private var tabSelection: String = ""
    
    var body: some View {
        TabView(selection: $tabSelection) {
            ForEach(viewModel.currentCampfireLogImagesData.images, id: \.imageId) { imageData in
                VStack {
                    Spacer()
                    CampfireLogDrawPhoto(imageName: imageData.imageName, isClip: false)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .tag(imageData.imageName)
            }
        }
        .background(.backgroundPhoto)
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onAppear {
            tabSelection = imageName
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
            
            ToolbarItem(placement: .principal) {
                VStack{
                    Text(selectedLog.address)
                        .foregroundStyle(.textColorWhite)
                        .font(Font.custom("Pretendard-Regular", size: 13))
                    // 혹시 몰라서 현재 보여지는 사진의 날짜를 가지고 오기는 하는데,,, 현재 로직 상 한 로그는 같은 날짜일거라서...흠
                    if let currentImage = viewModel.currentCampfireLogImagesData.images.first(where: { $0.imageName == tabSelection }) {
                        Text(viewModel.currentCampfireLogImageDetail?.takenAt.iso8601ToDate.logPileRowTitleDayFormat ?? Date().logPileRowTitleDayFormat)
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
