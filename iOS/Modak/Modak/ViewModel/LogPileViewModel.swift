//
//  LogPileViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/14/24.
//

import SwiftUI
import SwiftData

class LogPileViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Published var logs: [Log] = []

    init() {
        fetchLogs()
    }

    func fetchLogs() {
        let sortDescriptor = SortDescriptor(\Log.startAt, order: .reverse)
        do {
            logs = try modelContext.fetch(FetchDescriptor<Log>(sortBy: [sortDescriptor]))
        } catch {
            print("Failed to fetch logs: \(error)")
        }
    }
}
