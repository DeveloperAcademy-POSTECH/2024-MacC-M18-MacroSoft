//
//  CampfireLogsPreviewResult.swift
//  Modak
//
//  Created by Park Junwoo on 11/26/24.
//

import SwiftUI

struct CampfireLogsPreviewResult: Codable {
    var logOverviews: [LogOverview]
    var hasNext: Bool
}

struct LogOverview: Codable {
    var logId: Int
    var startAt: String
    var address: String
    var imageNames: [String]
}

// 월별로 일별 로그를 묶는 구조체
struct MonthlyLogsOverview {
    let id: UUID = UUID()
    var date: Date          // 날짜 (년, 월)
    var dailyLogs: [DailyLogsOverview] // 해당 월에 속한 일별 로그들
}

// 일별 로그를 묶는 구조체
struct DailyLogsOverview {
    var date: Date  // 날짜 (일)
    var logs: [LogOverview] // 해당 날짜에 속한 로그들
}
