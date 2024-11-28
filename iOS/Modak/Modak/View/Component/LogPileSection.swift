//
//  LogPileSection.swift
//  Modak
//
//  Created by Park Junwoo on 11/8/24.
//

import SwiftUI

struct LogPileSection: View {
    @Environment(\.modelContext) private var modelContext
    
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    
    private(set) var monthlyLog: [DailyLogs]
    
    var body: some View {
        ForEach(monthlyLog, id: \.date) { dailyLog in
            LogPileSectionRow(dailyLog: dailyLog)
                .background(LinearGradient.logPileRowBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding([.horizontal, .bottom], 10)
                .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                .onAppear {
                    logPileViewModel.fetchMoreLogsWithGroupBy(modelContext: modelContext, currentLog: dailyLog)
                }
        }
    }
}


private struct LogPileSectionRow: View {
    private(set) var dailyLog: DailyLogs
    
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
                                LogPileRowTitle(date: log.endAt, location: log.address, isLeaf: false)
                            } else {
                                LogPileRowTitle(date: log.endAt, location: log.address, isLeaf: true)
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
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.textColor2.opacity(0.2), lineWidth: 0.33)
            }
        }
    }
}

private struct LogPileRowTitle: View {
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
            Image(isLeaf ? .leaf3D : .log3D)
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
