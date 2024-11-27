//
//  CampfireLogPileView.swift
//  Modak
//
//  Created by Park Junwoo on 11/7/24.
//

import SwiftUI
import FirebaseAnalytics

struct CampfireLogPileView: View {
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    @EnvironmentObject private var viewModel: CampfireViewModel
    // TODO: 테스트용 변수들 추후 제거
    @State private var isEmpty: Bool = false
    
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
            if viewModel.currentCampfireYearlyLogs.isEmpty {
                VStack {
                    CampfireLogPileViewTitle(campfireName: viewModel.mainCampfireInfo!.campfireName, campfireMemberCount: (viewModel.mainCampfireInfo!.memberIds.count))
                        .padding(.leading, 24)
                    
                    Spacer()
                    
                    CampfireEmptyLog()
                    
                    Spacer()
                }
            } else {
                ScrollView {
                    CampfireLogPileViewTitle(campfireName: viewModel.mainCampfireInfo!.campfireName, campfireMemberCount: viewModel.mainCampfireInfo!.memberIds.count)
                        .padding(.leading, 24)
                        .padding(.bottom, 12)
                    
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        ForEach($viewModel.currentCampfireYearlyLogs, id: \.date){ monthlyLogOverview in
                            Section {
                                CampfireLogPileSection(monthlyLog: monthlyLogOverview.dailyLogs)
                            } header: {
                                LogPileHeader(date: monthlyLogOverview.date.wrappedValue)
                            }
                        }
                    }
                }
            }
            
            CampfireLogPileViewFloatingButton()
                .padding(.init(top: 0, leading: 0, bottom: 14, trailing: 24))
                .disabled(!networkMonitor.isConnected || logPileViewModel.yearlyLogs.isEmpty)
                .simultaneousGesture(TapGesture().onEnded {
                    if !networkMonitor.isConnected {
                        viewModel.showTemporaryNetworkAlert()
                    } else if logPileViewModel.yearlyLogs.isEmpty {
                        viewModel.showEmptyLogPileAlert()
                    }
                })
        }
        .background {
            LogPileBackground()
                .ignoresSafeArea()
        }
        .navigationTitle("\(viewModel.mainCampfireInfo!.campfireName) 모닥불")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "CampfireLogPileView",
                AnalyticsParameterScreenClass: "CampfireLogPileView"])
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
                
                NavigationLink {
                    SelectMergeLogsView()
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

private struct CampfireLogPileSection: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    
    @Binding private(set) var monthlyLog: [DailyLogsOverview]
    
    var body: some View {
        ForEach($monthlyLog, id: \.date) { dailyLog in
            CampfireLogPileSectionRow(dailyLog: dailyLog)
                .background(LinearGradient.logPileRowBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding([.horizontal, .bottom], 10)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                .onAppear {
                    //                    logPileViewModel.fetchMoreLogsWithGroupBy(modelContext: modelContext, currentLog: dailyLog)
                }
        }
    }
}


private struct CampfireLogPileSectionRow: View {
    @EnvironmentObject private var viewModel: CampfireViewModel
    
    @Binding private(set) var dailyLog: DailyLogsOverview
    
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 87), spacing: 1), count: 4)
    
    var body: some View {
        // TODO: 옵셔널 언래핑 실패 시 로직 구현
        if let dailyLogFirst = dailyLog.logs.first, let dailyLogLast = dailyLog.logs.last {
            VStack(spacing: 0) {
                ForEach($dailyLog.logs, id: \.logId) { log in
                    NavigationLink {
                        CampfireLogPileDetailView(selectedLog: log.wrappedValue)
                    } label: {
                        VStack(spacing: dailyLogFirst.logId == dailyLogLast.logId ? 14 : 12) {
                            if log.logId.wrappedValue == dailyLogFirst.logId || dailyLogFirst.logId == dailyLogLast.logId {
                                CampfireLogPileRowTitle(date: log.startAt.wrappedValue.iso8601ToDate, location: log.address.wrappedValue, isLeaf: false)
                            } else {
                                CampfireLogPileRowTitle(date: log.startAt.wrappedValue.iso8601ToDate, location: log.address.wrappedValue, isLeaf: true)
                            }
                            HStack(spacing: 14) {
                                if log.logId.wrappedValue != dailyLogLast.logId {
                                    Divider()
                                        .frame(width: 1)
                                        .background(.pagenationDisable)
                                        .padding(.init(top: -5, leading: 12, bottom: -7, trailing: 0))
                                }
                                if log.imageNames.count > 3 {
                                    CampfireLogPileLazyVGrid(log: log)
                                        .background(.backgroundLogPile)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            .padding(.bottom, log.logId.wrappedValue == dailyLogLast.logId ? 0 : 20)
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded({
                        Task {
                            await viewModel.getCampfireLogImages(logId: log.logId.wrappedValue)
                        }
                    }))
                }
            }
            .padding(.init(top: 16, leading: 10, bottom: 10, trailing: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.textColor2.opacity(0.2), lineWidth: 0.33)
            }
        }
    }
}

private struct CampfireLogPileLazyVGrid: View {
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 87), spacing: 1), count: 4)
    
    @Binding var log: LogOverview
    
    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 1) {
            ForEach(0..<((4...7).contains(log.imageNames.count) ? 4 : 8), id: \.self) { index in
                Group {
                    if (log.imageNames.count == 3 && index == 2) || (log.imageNames.count == 2 && index == 1) || (log.imageNames.count == 1 && index == 0) {
                        CampfireLogDrawPhoto(imageName: log.imageNames[index], isClip: true)
                        // clipShape 때문에 Group을 못 썼는데 이 로직으로 들어오는 경우가 없어서 일단 Group 사용함
                            .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                    } else {
                        CampfireLogDrawPhoto(imageName: log.imageNames[index], isClip: true)
                    }
                }
                .aspectRatio(1, contentMode: .fill)
                .foregroundStyle(.textColorTitleView)
            }
        }
    }
}

private struct CampfireLogPileRowTitle: View {
    private(set) var date: Date
    private(set) var location: String?
    private(set) var isLeaf: Bool
    
    init(date: Date, location: String? = nil, isLeaf: Bool) {
        self.date = date
        self.isLeaf = isLeaf
        if location == "위치 정보 없음" {
            self.location = "지구"
        }else {
            self.location = location
        }
    }
    
    var body: some View {
        // TODO: Text 표시하는 로직 수정
        HStack(spacing: 10) {
            Image(isLeaf ? .leaf : .log)
            VStack(alignment: .leading, spacing: 4) {
                Text(location ?? "지구")
                    .foregroundStyle(.textColor3)
                    .font(Font.custom("Pretendard-Bold", size: 16))
                +
                Text("에서 발견된 장작")
                    .foregroundStyle(.textColorGray1)
                    .font(Font.custom("Pretendard-Light", size: 15))
                
                Text("\(date.logPileRowTitleDayFormat) ")
                    .font(
                        Font.custom("Pretendard-Medium", size: 12)
                    )
                    .foregroundStyle(.textColorGray1.opacity(0.55))
                +
                Text(date.logPileRowTitleTimeFormat)
                    .font(
                        Font.custom("Pretendard-Medium", size: 12)
                    )
                    .foregroundStyle(.textColorGray4.opacity(0.54))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.textColorGray1)
        }
    }
}

#Preview{
    NavigationStack {
        CampfireLogPileView()
    }
}
