//
//  MonthlyLogs.swift
//  Modak
//
//  Created by Park Junwoo on 10/17/24.
//

import Foundation

// 월별로 일별 로그를 묶는 구조체
struct MonthlyLogs {
    let id: UUID = UUID()
    var date: Date          // 날짜 (년, 월)
    var dailyLogs: [DailyLogs] // 해당 월에 속한 일별 로그들
}
