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
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    
    var body: some View {
        Group {
            if logPileViewModel.yearlyLogs.count > 0 {
                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        ForEach($logPileViewModel.yearlyLogs, id: \.id) { monthlyLog in
                            Section {
                                LogPileSection(monthlyLog: monthlyLog.dailyLogs.wrappedValue)
                            } header: {
                                LogPileHeader(date: monthlyLog.date.wrappedValue)
                            }
                        }
                    }
                }
            } else {
                NoLogView()
                    .onAppear {
                        logPileViewModel.fetchLogsWithGroupBy(modelContext: modelContext)
                    }
            }
        }
        .background {
            LogPileBackground()
                .ignoresSafeArea()
        }
        .onAppear {
            logPileViewModel.fetchLogsWithGroupBy(modelContext: modelContext)
        }
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "LogPileView",
                AnalyticsParameterScreenClass: "LogPileView"])
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
