//
//  SelectCampfiresView.swift
//  Modak
//
//  Created by Park Junwoo on 11/5/24.
//

import SwiftUI
import SwiftData

// TODO: 테스트용 추후 제거
private class TestCampfire {
    var id: Int
    var title: String
    var todayImage: PublicLogImage?
    var pin: Int
    
    init(id: Int, title: String, todayImage: PublicLogImage? = nil, pin: Int) {
        self.id = id
        self.title = title
        self.todayImage = todayImage
        self.pin = pin
    }
}

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
                .environmentObject(networkMonitor)
                .padding(.init(top: 16, leading: 16, bottom: 10, trailing: 16))
                
                List(networkMonitor.isConnected ? viewModel.campfires : campfiresLocalData, id: \.pin) { campfire in
                    SelectCampfiresViewCampfireButton(
                        campfire: campfire,
                        isShowSideMenu: $isShowSideMenu
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
        .onAppear {
            viewModel.fetchUserCampfireInfos { _ in }
        }
    }
}

// MARK: - SelectCampfiresViewTopButton

private struct SelectCampfiresViewTopButton: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    private(set) var buttonImage: ImageResource
    private(set) var buttonText: String
    
    var body: some View {
        NavigationLink {
            switch buttonImage {
            case .milestone:
                JoinCampfireView()
            case .tent:
                CampfireNameView(isCreate: true)
                    .environmentObject(viewModel)
            default:
                CampfireNameView(isCreate: true)
                    .environmentObject(viewModel)
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
    var campfire: Campfire
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        if campfire.pin == viewModel.recentVisitedCampfirePin {
            Button {
                viewModel.updateRecentVisitedCampfirePin(to: campfire.pin)
                print("Updated recentVisitedCampfirePin to: \(viewModel.recentVisitedCampfirePin)")

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
                            Image(((campfire.image == nil || campfire.image == "") ? "progress_defaultImage" : campfire.image)!)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .aspectRatio(1, contentMode: .fit)
                            
                            VStack {
                                Text(campfire.name)
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
                viewModel.updateRecentVisitedCampfirePin(to: campfire.pin)
                print("Updated recentVisitedCampfirePin to: \(viewModel.recentVisitedCampfirePin)")

                withAnimation {
                    isShowSideMenu = false
                }
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.init(hex: "443D41"))
                    .overlay {
                        HStack(spacing: 12) {
                            Image(((campfire.image == nil || campfire.image == "") ? "progress_defaultImage" : campfire.image)!)
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .aspectRatio(1, contentMode: .fit)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(campfire.name)
                                    .font(Font.custom("Pretendard-SemiBold", size: 14))
                                    .foregroundStyle(.textColorGray2)
                                
                                HStack(spacing: 2){
                                    ForEach(Array(campfire.membersNames.prefix(3).enumerated()), id: \.0) { index ,member in
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
                                    if campfire.membersNames.count > 3 {
                                        Text("+\(campfire.membersNames.count - 3)")
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
