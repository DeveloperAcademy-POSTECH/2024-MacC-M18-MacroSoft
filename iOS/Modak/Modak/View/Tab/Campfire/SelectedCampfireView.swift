//
//  SelectedCampfireView.swift
//  Modak
//
//  Created by Park Junwoo on 11/1/24.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics
import Kingfisher

struct SelectedCampfireView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var viewModel: CampfireViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var campfiresLocalData: [Campfire]
    @Binding private(set) var isShowSideMenu: Bool
    @AppStorage("isInitialDataLoad") private var isInitialDataLoad: Bool = true
    
    var body: some View {
        if viewModel.mainTodayImage != nil {
            CampfireMainAvatarView()
                .padding(.bottom, -210)
        }
        VStack {
            // TODO: 네트워크가 연결되지 않은 경우 로컬 데이터를 사용
            if viewModel.mainCampfireInfo != nil {
                CampfireViewTopButton(isShowSideMenu: $isShowSideMenu)
                
                if viewModel.mainTodayImage == nil {
                    CampfireEmptyLog()
                    
                    Spacer()
                } else {
                    CampfireViewTodayPhoto()
                    
                    Spacer()
                    
                    ExpandableEmoji(emojiList: ["😀", "😅", "😱", "😭", "❤️", "☠️"])
                        .padding(.trailing, 24)
                        .padding(.bottom)
                }
                
                // 추가 콘텐츠
            } else {
                Text(networkMonitor.isConnected ? "캠프파이어 정보를 불러오는 중" : "캠프파이어 정보가 없습니다.\n인터넷 연결 후 다시 시도해 주세요.")
                    .foregroundStyle(.textColorGray2)
                    .font(Font.custom("Pretendard-Regular", size: 18))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .onAppear {
            if isInitialDataLoad {
                fetchAndSaveCampfireToLocalStorage()
            } else {
                viewModel.fetchCampfireMainInfo()
            }
        }
    }

    private func fetchAndSaveCampfireToLocalStorage() {
        viewModel.fetchUserCampfireInfos { campfires in
            if let campfires = campfires {
                for campfire in campfires {
                    self.modelContext.insert(campfire)
                }
                viewModel.recentVisitedCampfirePin = campfires.first!.pin
                self.isInitialDataLoad = false
                do {
                    try modelContext.save()
                    print("Campfire 데이터 - 로컬 데이터베이스 저장")
                } catch {
                    print("Error saving Campfire data: \(error)")
                }
            }
        }
//        .onAppear {
//            if isInitialDataLoad {
//                fetchAndSaveCampfireToLocalStorage()
//            } else {
//                viewModel.fetchCampfireMainInfo()
//            }
//        }
//        .onChange(of: isShowSideMenu) {
            
//            viewModel.fetchUserCampfireInfos { _ in
//                Task {
//                    if let imageURLName = viewModel.currentCampfire?.imageName, let uiImage = await viewModel.fetchTodayImage(imageURLName: imageURLName) {
//                        mainTodayUIImage = uiImage
//                    }
//                }
//            }
//        }
//        .onAppear {
//            Task {
//                if let imageURLName = viewModel.currentCampfire?.imageName, let uiImage = await viewModel.fetchTodayImage(imageURLName: imageURLName) {
//                    mainTodayUIImage = uiImage
//                }
//            }
//        }
    }

//    private func fetchAndSaveCampfireToLocalStorage() {
//        viewModel.fetchUserCampfireInfos { campfires in
//            if let campfires = campfires {
//                for campfire in campfires {
//                    self.modelContext.insert(campfire)
//                }
//                viewModel.recentVisitedCampfirePin = campfires.first!.pin
//                self.isInitialDataLoad = false
//                do {
//                    try modelContext.save()
//                    print("Campfire 데이터 - 로컬 데이터베이스 저장")
//                } catch {
//                    print("Error saving Campfire data: \(error)")
//                }
//            }
//        }
//    }
}

// MARK: - CampfireViewTopButton

private struct CampfireViewTopButton: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    isShowSideMenu = true
                }
            } label: {
                HStack(spacing: 8) {
                    if let todayImageURL = campfireViewModel.mainTodayImageURL {
                        KFImage(todayImageURL)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } else {
                        Image(.photosIcon)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Text(campfireViewModel.mainCampfireInfo?.campfireName ?? "")
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .foregroundStyle(.textColor1)
                        .font(Font.custom("Pretendard-Semibold", size: 18))
                }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 10))
            }
            .background {
                Rectangle().fill(Color.init(hex: "221F20")).clipShape(.rect(bottomTrailingRadius: 12, topTrailingRadius: 12))
            }
            
            Spacer(minLength: 16)
            
            NavigationLink {
                CampfireLogPileView()
            } label: {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.init(hex: "221F20"))
                    .stroke(Color.init(hex: "6E615F").opacity(0.32), lineWidth: 1)
                    .frame(width: 45, height: 45)
                    .overlay {
                        Image(.logs)
                            .resizable()
                            .padding(4)
                    }
            }
            .padding(.trailing)
            .padding(.top, 6)
            .simultaneousGesture(TapGesture().onEnded({
                Task {
                    await campfireViewModel.testFetchCampfireLogsPreview()
                }
            }))
        }
        .padding(.bottom)
    }
}

// MARK: - CampfireViewTodayPhoto

private struct CampfireViewTodayPhoto: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    
    @State private var randomRotation: Bool = Bool.random()
    @State private var isTodayPhotoFullSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                isTodayPhotoFullSheet = true
                Analytics.logEvent("Image_tapped", parameters: [:])
            } label: {
                if let todayImageURL = campfireViewModel.mainTodayImageURL {
                    KFImage.url(todayImageURL)
                        .onSuccess { result in
                            self.todayImageHeight = result.image.size.height
                        }
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 8))
                } else {
                    Image(.photosIcon)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 8))
                }
            }
            
            Text("오늘의 사진")
                .font(Font.custom("Pretendard-medium", size: 16))
                .foregroundStyle(.textColorTitleView)
                .padding(.bottom, 8)
        }
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.init(hex: "221F20"))
                .stroke(Color.init(hex: "6E615F").opacity(0.32), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.25), radius: 9.09486, x: 0, y: 4.54743)
        .frame(width: 320, height: min(campfireViewModel.mainTodayImage?.size.height ?? 320, 320))
        .rotationEffect(.degrees(randomRotation ? 2 : -2))
        .fullScreenCover(isPresented: $isTodayPhotoFullSheet) {
            ExpandedPhoto()
                .presentationBackground(Color.black.opacity(0.8))
        }
    }
}

#Preview {
    SelectedCampfireView(isShowSideMenu: .constant(false))
}
