//
//  LogPileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SwiftData
import Photos
import Firebase

struct LogPileView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var yearlyLogs: [(MonthlyLogs)] = []
    
    var body: some View {
        Group {
            if yearlyLogs.count > 0 {
                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        ForEach($yearlyLogs, id: \.date){ monthlyLog in
                            Section {
                                ForEach(monthlyLog.dailyLogs, id: \.date) { dailyLog in
                                    LogPileViewRow(dailyLog: dailyLog)
                                        .background(LinearGradient.logPileRowBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding([.horizontal, .bottom], 10)
                                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                                }
                            } header: {
                                LogPileViewSubTitle(date: monthlyLog.date.wrappedValue)
                            }
                        }
                    }
                }
            } else {
                NoLogView()
            }
        }
        .background(.backgroundLogPile)
        .onAppear {
            fetchLogsWithGroupBy()
        }
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "LogPileView",
                AnalyticsParameterScreenClass: "LogPileView"])
        }
    }
    
    // MARK: - fetchLogsWithGroupBy
    
    private func fetchLogsWithGroupBy() {
        do {
            let logs = try modelContext.fetch(FetchDescriptor<PrivateLog>())
            
            // logs: [Log]를, monthlyLogs(MonthlyLogs Model과는 다름): [Date : [Log]] 형태로 (년, 월 기준으로)
            let monthlyLogs = Dictionary(grouping: logs) { log in
                let components = Calendar.current.dateComponents([.year, .month], from: log.startAt)
                return Calendar.current.date(from: components)!
            }
            
            // YearlyLogs를 최신 순으로 정렬하고, 각 월 안에서 다시 일별로 그룹화
            yearlyLogs = monthlyLogs.sorted { $0.key > $1.key } // 최신 월 순으로 정렬
                .map { (month, logsInMonth) in
                    // 같은 월 안에서 다시 일별로 그룹화
                    let dailyLogs = Dictionary(grouping: logsInMonth) { log in
                        Calendar.current.startOfDay(for: log.startAt) // 일 단위로 그룹화
                    }
                    
                    // 날짜별 로그들을 최신 날짜 순으로 정렬
                    let sortedDailyLogs = dailyLogs.sorted { $0.key > $1.key }
                        .map { (day, logsInDay) in
                            DailyLogs(date: day, logs: logsInDay.sorted { $0.startAt > $1.startAt }) // 시간순으로 정렬
                        }
                    
                    // 월 단위로 묶고, 그 안에 일별로 묶인 로그들 포함
                    return MonthlyLogs(date: month, dailyLogs: sortedDailyLogs)
                }
        } catch {
            print("fetchLogsWithGroupBy failed: \(error)")
        }
    }
}

// MARK: - LogPileViewSubTitle

private struct LogPileViewSubTitle: View {
    private(set) var date: Date
    // TODO: calendar는 초기값을 넣어주는 형태라서 private만 줬는데 오류가 발생해서 private(set)으로 변경...왜...?
    private(set) var calendar: Calendar = .current
    
    var body: some View {
        // TODO: Text 표시하는 로직 수정
        // TODO: date가 혹시라도 nil이거나 dateComponents를 통해 나온 날짜 값이 nil인 경우 처리
        Group {
            if let year = calendar.dateComponents([.year], from: date).year, let month = calendar.dateComponents([.month], from: date).month{
                Text("\(year.description)년 ")
                    .foregroundStyle(.textColor4)
                    .font(Font.custom("Pretendard-Bold", size: 21))
                +
                Text("\(month)월")
                    .foregroundStyle(.textColor2)
                    .font(Font.custom("Pretendard-Medium", size: 21))
            } else {
                Text("년 ")
                    .foregroundStyle(.textColor4)
                    .font(Font.custom("Pretendard-Bold", size: 21))
                +
                Text("월")
                    .foregroundStyle(.textColor2)
                    .font(Font.custom("Pretendard-Medium", size: 21))
            }
            
        }
        .padding(.leading, 24)
    }
}

// MARK: - LogPileViewRowTitle

private struct LogPileViewRowTitle: View {
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

// MARK: - LogPileViewRowFrame

private struct LogPileViewRowFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.textColor2.opacity(0.2), lineWidth: 0.33)
    }
}

// MARK: - LogPileViewRow

private struct LogPileViewRow: View {
    @Binding private(set) var dailyLog: DailyLogs
    
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 87), spacing: 1), count: 4)
    
    var body: some View {
        // TODO: 옵셔널 언래핑 실패 시 로직 구현
        if let dailyLogFirst = dailyLog.logs.first, let dailyLogLast = dailyLog.logs.last {
            VStack(spacing: 0) {
                ForEach(dailyLog.logs, id: \.id) { log in
                    NavigationLink {
                        LogPileDetailView(selectedLog: log)
                    } label: {
                        VStack(spacing: dailyLogFirst.id == dailyLogLast.id ? 14 : 12) {
                            if log.id == dailyLogFirst.id || dailyLogFirst.id == dailyLogLast.id {
                                LogPileViewRowTitle(date: log.endAt, location: log.address, isLeaf: false)
                            } else {
                                LogPileViewRowTitle(date: log.endAt, location: log.address, isLeaf: true)
                            }
                            HStack(spacing: 14) {
                                if log.id != dailyLogLast.id {
                                    Divider()
                                        .frame(width: 1)
                                        .background(.pagenationDisable)
                                        .padding(.init(top: -5, leading: 12, bottom: -7, trailing: 0))
                                }
                                LazyVGrid(columns: gridItems, spacing: 1) {
                                    ForEach(0..<((4...7).contains(log.sortedImages.count) ? 4 : 8), id: \.self) { index in
                                        Group {
                                            if (log.sortedImages.count == 3 && index == 2) || (log.sortedImages.count == 2 && index == 1) || (log.sortedImages.count == 1 && index == 0) {
                                                DrawPhoto(photoMetadata: log.sortedImages[index], isClip: true)
                                                // clipShape 때문에 Group을 못 썼는데 이 로직으로 들어오는 경우가 없어서 일단 Group 사용함
                                                    .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                                            } else {
                                                DrawPhoto(photoMetadata: log.sortedImages[index], isClip: true)
                                            }
                                        }
                                        .aspectRatio(1, contentMode: .fill)
                                        .foregroundStyle(.textColorTitleView)
                                    }
                                }
                                .background(.backgroundLogPile)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .padding(.bottom, log.id == dailyLogLast.id ? 0 : 20)
                        }
                    }
                }
            }
            .padding(.init(top: 16, leading: 10, bottom: 10, trailing: 10))
            .overlay {
                LogPileViewRowFrame()
            }
        }
        
    }
}

// MARK: - NoLogView

private struct NoLogView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("캠핑장이 너무 추워요")
                .font(
                    Font.custom("Pretendard-Bold", size: 22)
                )
                .foregroundColor(.textColorGray1)
                .padding(.bottom, 8)
            
            Text("따뜻하게 불을 지필 수 있도록 \n내 사진으로 장작을 만들어주세요")
                .font(Font.custom("Pretendard-Regular", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.textColorGray2)
                .padding(.bottom, 27)
                .lineSpacing(16 * 0.5)
            
            NavigationLink {
                AuthorizationView()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.mainColor1)
                    .overlay {
                        Text("내 사진에서 장작 구해오기")
                            .font(
                                Font.custom("Pretendard-Bold", size: 16)
                            )
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                    }
            }
            .frame(height: 51)
            .padding(.horizontal, UIScreen.main.bounds.size.width / 5)
            Spacer()
        }
        .padding(.top, -30)
    }
}

#Preview {
    LogPileView()
}
