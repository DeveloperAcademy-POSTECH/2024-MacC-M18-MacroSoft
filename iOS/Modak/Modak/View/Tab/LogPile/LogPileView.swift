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
                                    LogPileRow(dailyLog: dailyLog)
                                        .background(LinearGradient.logPileRowBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding([.horizontal, .bottom], 10)
                                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                                }
                            } header: {
                                LogPileSectionTitle(date: monthlyLog.date.wrappedValue)
                            }
                        }
                    }
                }
            } else {
                NoLogView()
            }
        }
        .background {
            LogPileBackground()
                .ignoresSafeArea()
        }
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
