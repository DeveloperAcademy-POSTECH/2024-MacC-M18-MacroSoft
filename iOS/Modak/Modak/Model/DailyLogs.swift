//
//  DailyLogs.swift
//  Modak
//
//  Created by Park Junwoo on 10/17/24.
//

import Foundation

// 일별 로그를 묶는 구조체
struct DailyLogs {
    var date: Date  // 날짜 (일)
    var logs: [Log] // 해당 날짜에 속한 로그들
}
