//
//  LogPileViewModel.swift
//  Modak
//
//  Created by Park Junwoo on 11/6/24.
//

import SwiftUI
import SwiftData

class LogPileViewModel: ObservableObject {
    @Published var yearlyLogs: [(MonthlyLogs)] = []
    
    private var currentPage = 1 // 페이지네이션을 위한 페이지 변수
    private var isFetchingPage: Bool = false // fetch 중일 때 중복 호출 막는 변수
    private var isLastPage: Bool = false // 페이지네이션에서 마지막 페이지인지 체크하는 변수
    private let pageSize = 4 // 페이지네이션 당 호출 수
    
    // 첫 호출(페이지네이션 x)
    func fetchLogsWithGroupBy(modelContext: ModelContext) {
        if !isFetchingPage {

            isFetchingPage = true
            
            do {
                var descriptor = FetchDescriptor<PrivateLog>()
                descriptor.fetchLimit = pageSize
                descriptor.fetchOffset = 0
                
                let logs = try modelContext.fetch(descriptor)

                if logs.count < pageSize && logs.count > 0 {
                    isLastPage = true
                }
                
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
                
                isFetchingPage = false
            } catch {
                print("fetchLogsWithGroupBy failed: \(error)")
                isFetchingPage = false
            }
        }
    }
    
    // 두번째부터 호출(페이지네이션 o)
    func fetchMoreLogsWithGroupBy(modelContext: ModelContext, currentLog: DailyLogs) {

        if !isLastPage && !isFetchingPage && yearlyLogs.last?.dailyLogs.last?.date == currentLog.date {

            isFetchingPage = true
            
            do {
                // FetchDescriptor에 fetchLimit과 fetchOffset을 추가하여 페이지네이션 적용
                var descriptor = FetchDescriptor<PrivateLog>()
                descriptor.fetchLimit = pageSize
                descriptor.fetchOffset = currentPage * pageSize
                
                let logs = try modelContext.fetch(descriptor)
                
                if logs.count < pageSize {
                    isLastPage = true
                }
                
                // logs를 월별 및 일별로 그룹화
                let monthlyLogs = Dictionary(grouping: logs) { log in
                    let components = Calendar.current.dateComponents([.year, .month], from: log.startAt)
                    return Calendar.current.date(from: components)!
                }
                
                let sortedLogs = monthlyLogs.sorted { $0.key > $1.key }
                    .map { (month, logsInMonth) in
                        let dailyLogs = Dictionary(grouping: logsInMonth) { log in
                            Calendar.current.startOfDay(for: log.startAt)
                        }
                        let sortedDailyLogs = dailyLogs.sorted { $0.key > $1.key }
                            .map { (day, logsInDay) in
                                DailyLogs(date: day, logs: logsInDay.sorted { $0.startAt > $1.startAt })
                            }
                        return MonthlyLogs(date: month, dailyLogs: sortedDailyLogs)
                    }
                
                yearlyLogs.append(contentsOf: sortedLogs)
                
                // 다음 페이지로 이동하도록 설정
                currentPage += 1
                
                isFetchingPage = false
            } catch {
                print("fetchLogsWithGroupBy failed: \(error)")
                isFetchingPage = false
            }
        }
    }
}
