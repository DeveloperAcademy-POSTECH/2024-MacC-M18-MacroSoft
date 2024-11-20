//
//  SelectedCampfireView.swift
//  Modak
//
//  Created by Park Junwoo on 11/1/24.
//

import SwiftUI
import SwiftData

struct SelectedCampfireView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var viewModel: CampfireViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var campfiresLocalData: [Campfire]
    // TODO: 참여한 모닥불의 로그가 없는지 체크하는 로직 추가
    @State private var isEmptyCampfireLog: Bool = true
    @Binding private(set) var isShowSideMenu: Bool
    @AppStorage("isInitialDataLoad") private var isInitialDataLoad: Bool = true
    
    var body: some View {
        VStack {
            // 네트워크가 연결되지 않은 경우 로컬 데이터를 사용
            // TODO: 참여한 캠프파이어가 없을 경우에 모닥불 참여를 눌렀을 때, 언래핑 오류가 떠서 수정하긴 했으나 확인 필요
            if let viewModelCampfire = viewModel.campfire, let campfire = (networkMonitor.isConnected ? viewModelCampfire : campfiresLocalData.first(where: { $0.pin == viewModel.recentVisitedCampfirePin })) {
                CampfireViewTopButton(isShowSideMenu: $isShowSideMenu, campfireName: campfire.name)
                
                // TODO: 참여한 모닥불의 로그가 없는지 체크하는 로직 추가
                if isEmptyCampfireLog {
                    CampfireEmptyLog(campfireName: campfire.name)
                    
                    Spacer()
                } else {
                    CampfireViewTodayPhoto(image: "photosIcon")
                    
                    Spacer()
                    
                    ExpandableEmoji(emojiList: ["laugh", "embarrassed", "panic", "cry", "heart", "death"])
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
    }
}

// MARK: - CampfireViewTopButton

private struct CampfireViewTopButton: View {
    @Binding private(set) var isShowSideMenu: Bool
    var campfireName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    isShowSideMenu = true
                }
            } label: {
                HStack(spacing: 8) {
                    // TODO: 모닥불 이미지 적용하는 로직 추가
                    Image(.leaf3D)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(campfireName)
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
                // TODO: 해당 모닥불의 장작 창고로 이동하는 로직 추가
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
        }
        .padding(.bottom)
    }
}

// MARK: - CampfireViewTodayPhoto

private struct CampfireViewTodayPhoto: View {
    @State private var randomRotation: Bool = Bool.random()
    @State private var isTodayPhotoFullSheet: Bool = false
    var image: String = "photosIcon"
    
    // TODO: 오늘의 사진 높이가 320 넘는지 판별하는 로직 추가하기
    private var isTodayPhotoHeightOver320: Bool = false
    
    init(image: String) {
        self.image = image
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                isTodayPhotoFullSheet = true
            } label: {
                // TODO: 오늘의 이미지 넣는 로직 추가
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 8))
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
        // TODO: 오늘의 사진 높이가 320 넘는지 판별하는 로직 추가하기
        .frame(width: 320, height: isTodayPhotoHeightOver320 ? 320 : .infinity)
        .rotationEffect(.degrees(randomRotation ? 2 : -2))
        .fullScreenCover(isPresented: $isTodayPhotoFullSheet) {
            // TODO: 선택한 이미지가 보이도록 로직 추가
            ExpandedPhoto(photo: .progressDefault)
                .presentationBackground(Color.black.opacity(0.8))
        }
    }
}

#Preview {
    SelectedCampfireView(isShowSideMenu: .constant(false))
}
