//
//  CampfireLogPileView.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI

struct CampfireLogPileView: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    // TODO: 테스트용 변수들 추후 제거
    @State private var isEmpty: Bool = false
    @State private var yearlyLogs: [(MonthlyLogs)] = []
    
    init() {
        let appearanceWhenNotScrolled = UINavigationBarAppearance()
        appearanceWhenNotScrolled.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 0, weight: .semibold),
            .foregroundColor: UIColor.clear
        ]
        appearanceWhenNotScrolled.configureWithTransparentBackground()
        
        let appearanceWhenScrolled = UINavigationBarAppearance()
        appearanceWhenScrolled.titleTextAttributes = [
            .font: UIFont.init(name: "Pretendard-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold),
            .foregroundColor: UIColor.textColorTitleView
        ]
        appearanceWhenScrolled.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        UINavigationBar.appearance().standardAppearance = appearanceWhenScrolled
        UINavigationBar.appearance().scrollEdgeAppearance = appearanceWhenNotScrolled
    }
    
    var body: some View {
        ZStack {
            // TODO: 캠프파이어 로그가 없는지 체크하는 로직 추가
            if isEmpty {
                VStack {
                    CampfireLogPileViewTitle(campfireName: viewModel.campfire!.name, campfireMemberCount: (viewModel.campfire!.membersNames.isEmpty ? viewModel.campfire!.memberIds.count : viewModel.campfire!.membersNames.count))
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    CampfireEmptyLog(campfireName: viewModel.campfire!.name)
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    CampfireLogPileViewTitle(campfireName: viewModel.campfire!.name, campfireMemberCount: (viewModel.campfire!.membersNames.isEmpty ? viewModel.campfire!.memberIds.count : viewModel.campfire!.membersNames.count))
                        .padding(.leading, 24)
                        .padding(.bottom, 12)
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        ForEach($yearlyLogs, id: \.date){ monthlyLog in
                            Section {
                                LogPileSection(monthlyLog: monthlyLog.dailyLogs.wrappedValue)
                            } header: {
                                LogPileHeader(date: monthlyLog.date.wrappedValue)
                            }
                        }
                    }
                }
            }
            
            CampfireLogPileViewFloatingButton()
                .padding(.init(top: 0, leading: 0, bottom: 14, trailing: 24))
        }
        .background {
            LogPileBackground()
                .ignoresSafeArea()
        }
        .navigationTitle("\(viewModel.campfire!.name) 모닥불")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
    }
}

private struct CampfireLogPileViewTitle: View {
    private(set) var campfireName: String
    private(set) var campfireMemberCount: Int
    
    var body: some View {
        HStack {
            Text("\(campfireName) 모닥불")
                .foregroundStyle(.textColor1)
                .font(.custom("Pretendard-Bold", size: 18))
                .padding(.trailing, 4)
            
            // TODO: CampfireNameView 화면 데이터 연결
            NavigationLink {
                CampfireNameView(isCreate: false)
            } label: {
                Image(systemName: "pencil.line")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 20)
                    .foregroundStyle(.textColorGray1)
            }
            .padding(.trailing, 12)
            
            NavigationLink {
                CampfireMemberDetailView()
            } label: {
                HStack(spacing: 4) {
                    Text("멤버")
                        .foregroundStyle(.textColorTitleView)
                        .font(.custom("Pretendard_Medium", size: 12))
                        .padding(.init(top: 6, leading: 8, bottom: 6, trailing: 0))
                    
                    Text("\(campfireMemberCount)명")
                        .foregroundStyle(.textColorGray2)
                        .font(.custom("Pretendard_Medium", size: 14))
                        .padding(.init(top: 6, leading: 0, bottom: 6, trailing: 8))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.profileButtonBackground,lineWidth: 1)
                }
            }
            
            Spacer()
        }
    }
}

private struct CampfireLogPileViewFloatingButton: View {
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                // TODO: SelectMergeLogs 화면으로 연결
                NavigationLink {
                    
                } label: {
                    Circle()
                        .fill(Color.init(hex: "4C4545"))
                        .stroke(Color.mainColor2, lineWidth: 1)
                        .frame(width: 62, height: 62)
                        .shadow(color: .black.opacity(0.15), radius: 17.44, y: 5.23)
                        .overlay {
                            AddCampfireLogImage()
                        }
                }
            }
        }
    }
}

#Preview{
    NavigationStack {
        CampfireLogPileView()
    }
}
