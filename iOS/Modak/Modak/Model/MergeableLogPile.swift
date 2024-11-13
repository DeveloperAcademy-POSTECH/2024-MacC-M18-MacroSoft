//
//  MergeableLogPile.swift
//  Modak
//
//  Created by Park Junwoo on 11/12/24.
//

import Foundation

struct MergeableLogPile {
    var id: UUID
    var isRecommendedLogPile: Bool
    var mergeableLogs: [MergeableLog]
    
    init(isRecommendedLogPile: Bool, mergeableLogs: [MergeableLog]) {
        self.id = UUID()
        self.isRecommendedLogPile = isRecommendedLogPile
        self.mergeableLogs = mergeableLogs
    }
    
    static var recommendedMergeableLogPile: MergeableLogPile {
        .init(isRecommendedLogPile: true, mergeableLogs: [MergeableLog.testSelectedMergeableLog, MergeableLog.testNotSelectedMergeableLog])
    }
    
    static var notRecommendedMergeableLogPile: MergeableLogPile {
        .init(isRecommendedLogPile: false, mergeableLogs: [MergeableLog.testSelectedMergeableLog, MergeableLog.testNotSelectedMergeableLog])
    }
    
    func hasSelectedMergeableLogInLogPile() -> Bool {
        return mergeableLogs.contains { $0.isSelectedLog }
    }
}

// [MergeableLogPile] 배열에 isSelectedLog를 가진 데이터가 있는지 체크하는 Array extension
extension Array where Element == MergeableLogPile {
    func hasSelectedMergeableLogInLogPiles() -> Bool {
        return self.contains { $0.hasSelectedMergeableLogInLogPile() }
    }
}
