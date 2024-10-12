//
//  LogPileViewTestModel.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import Foundation

let logPileViewTestData: LogPileTestModel = LogPileTestModel(logList: (0..<10).map { monthOffset in
    let logDate = Calendar.current.date(byAdding: .month, value: monthOffset, to: Date()) ?? Date()
    let pictureCount = Int.random(in: 1...15) // 5~15 사이의 랜덤 개수
    let pictureList = (0..<pictureCount).map { _ in
        let pictureDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 0...30), to: logDate) ?? logDate
        return PictureTestModel(date: pictureDate, locationName: "포항시 남구")
    }
    return LogTestModel(date: logDate, pictureList: pictureList)
})

struct LogPileTestModel {
    var logList: [LogTestModel]
}

struct LogTestModel: Hashable {
    var date: Date
    var pictureList: [PictureTestModel]
}

struct PictureTestModel: Hashable {
    var id: UUID = UUID()
    var date: Date
    var locationName: String
}
