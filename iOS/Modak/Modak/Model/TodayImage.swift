//
//  TodayImage.swift
//  Modak
//
//  Created by Park Junwoo on 11/21/24.
//

import SwiftData

struct TodayImage: Codable {
    var imageId: Int
    var name: String
    var emotions: [Emotion]
}

struct Emotion: Codable {
    var memberNickname: String
    var emotion: String
}
