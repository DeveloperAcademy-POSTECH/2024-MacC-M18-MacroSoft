//
//  SelectCampfiresView.swift
//  Modak
//
//  Created by Park Junwoo on 11/5/24.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics
import Kingfisher

struct SelectCampfiresView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @Binding private(set) var isShowSideMenu: Bool
    @Query var campfiresLocalData: [Campfire]
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("내 모닥불")
                    .font(Font.custom("Pretendard-SemiBold", size: 17))
                    .foregroundStyle(.textColor1)
                    .padding(.top, 8)
                    .padding(.leading, 24)
                
                HStack(spacing: 8) {
                    SelectCampfiresViewTopButton(buttonImage: .milestone, buttonText: "모닥불 참여")
                    SelectCampfiresViewTopButton(buttonImage: .tent, buttonText: "모닥불 생성")
                }
                .padding(.init(top: 16, leading: 16, bottom: 10, trailing: 16))
                
                List(viewModel.myCampfireInfos, id: \.campfirePin) { campfire in
                    SelectCampfiresViewCampfireButton(
                        isShowSideMenu: $isShowSideMenu, campfireInfo: campfire
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
                    .listRowBackground(Color.clear)
                }
                .contentMargins(.all, 0)
                .scrollContentBackground(.hidden)
            }
            
            Spacer()
        }
//        .onAppear {
//            viewModel.fetchUserCampfireInfos { _ in }
//        }
    }
}

// MARK: - SelectCampfiresViewTopButton

private struct SelectCampfiresViewTopButton: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    private(set) var buttonImage: SwiftUI.ImageResource
    private(set) var buttonText: String
    
    var body: some View {
        NavigationLink {
            switch buttonImage {
            case .milestone:
                JoinCampfireView()
            case .tent:
                CampfireNameView(isCreate: true)
            default:
                CampfireNameView(isCreate: true)
            }
        } label: {
            RoundedRectangle(cornerRadius: 43)
                .fill(Color.init(hex: "464141"))
                .stroke(Color.init(hex: "4B4B4B"), lineWidth: 1)
                .overlay {
                    VStack(spacing: 8) {
                        Image(buttonImage)
                            .resizable()
                            .scaledToFit()
                        
                        Text(buttonText)
                            .font(Font.custom("Pretendard-SemiBold", size: 14))
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical, 8)
                }
        }
        .frame(height: 70)
        .disabled(!networkMonitor.isConnected)
        .simultaneousGesture(TapGesture().onEnded {
            if !networkMonitor.isConnected {
                viewModel.showTemporaryNetworkAlert()
            }
        })
    }
}

// MARK: - SelectCampfiresViewCampfireButton

private struct SelectCampfiresViewCampfireButton: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    
    @Binding private(set) var isShowSideMenu: Bool
    
    var campfireInfo: CampfireInfo
    
    var body: some View {
        
        if campfireInfo.campfirePin == viewModel.currentCampfirePin {
            Button {
                //                    viewModel.updateRecentVisitedCampfirePin(to: campfireInfo.campfirePin)
                //                    viewModel.currentCampfire = campfire
                //                    print("Updated recentVisitedCampfirePin to: \(viewModel.recentVisitedCampfirePin)")
                Task {
                    await viewModel.testFetchCampfireInfos()
                    await viewModel.testFetchMainCampfireInfo()
                    await viewModel.fetchTodayImageURL()
                }
                withAnimation {
                    isShowSideMenu = false
                }
            } label: {
                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                    .fill(Color(hex: "464141"))
                    .overlay(
                        UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                            .strokeBorder(.mainColor2, lineWidth: 1)
                            .clipShape(
                                UnevenRoundedRectangle(cornerRadii: .init(bottomTrailing: 20, topTrailing: 20))
                            )
                            .mask(
                                Rectangle()
                                    .padding(.leading, 1)
                            )
                    )
                    .overlay {
                        HStack(spacing: 12) {
                            if let imageURL = viewModel.getWebpImageDataURL(imageURLName: campfireInfo.imageName) {
                                KFImage(imageURL)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .aspectRatio(1, contentMode: .fit)
                            } else {
                                Image(.photosIcon)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .aspectRatio(1, contentMode: .fit)
                            }
                            
                            VStack {
                                Text(campfireInfo.campfireName)
                                    .font(Font.custom("Pretendard-SemiBold", size: 14))
                                    .foregroundStyle(.white)
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                    }
            }
            .frame(height: 72)
            .padding(.trailing)
        } else {
            Button {
                //                    viewModel.updateRecentVisitedCampfirePin(to: campfireInfo.campfirePin)
                Task {
                    viewModel.currentCampfireYearlyLogs = []
                    await viewModel.testChangeCurrentCampfirePin(campfireInfo.campfirePin)
                    await viewModel.testFetchCampfireInfos()
                    await viewModel.testFetchMainCampfireInfo()
                    await viewModel.fetchTodayImageURL()
                }
                Analytics.logEvent("campfire_change_tapped", parameters: ["changedCampfire": campfireInfo.campfireName])
                //                    viewModel.updateRecentVisitedCampfirePin(to: campfireInfo.campfirePin)
                //                    print("Updated recentVisitedCampfirePin to: \(viewModel.recentVisitedCampfirePin)")
                
                withAnimation {
                    isShowSideMenu = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.init(hex: "443D41"))
                    .overlay {
                        HStack(spacing: 12) {
                            if let imageURL = viewModel.getWebpImageDataURL(imageURLName: campfireInfo.imageName) {
                                KFImage(imageURL)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .aspectRatio(1, contentMode: .fit)
                            } else {
                                Image(.photosIcon)
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .aspectRatio(1, contentMode: .fit)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(campfireInfo.campfireName)
                                    .font(Font.custom("Pretendard-SemiBold", size: 14))
                                    .foregroundStyle(.textColorGray2)
                                
                                HStack(spacing: 2){
                                    ForEach(Array(campfireInfo.membersNames.prefix(3).enumerated()), id: \.0) { index ,member in
                                        if index < 3{
                                            Text(member, textLimit: 4)
                                                .foregroundStyle(Color.init(hex: "B58580"))
                                                .padding(6)
                                                .background {
                                                    RoundedRectangle(cornerRadius: 13)
                                                        .fill(Color.init(hex: "4D4343"))
                                                }
                                        }
                                    }
                                    if campfireInfo.membersNames.count > 3 {
                                        Text("+\(campfireInfo.membersNames.count - 3)")
                                            .padding(6)
                                            .foregroundStyle(.textColor2)
                                            .background {
                                                RoundedRectangle(cornerRadius: 13)
                                                    .stroke(Color.init(hex: "4D4343"), lineWidth: 1)
                                            }
                                    }
                                }
                                .font(Font.custom("Pretendard-Medium", size: 11))
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                    }
            }
            .frame(height: 72)
            .padding(.leading, 12)
            .padding(.trailing)
        }
    }
}

#Preview {
    SelectCampfiresView(isShowSideMenu: .constant(true))
}
