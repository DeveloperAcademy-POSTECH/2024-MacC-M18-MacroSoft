//
//  CampfireTodayImageEmotionResult.swift
//  Modak
//
//  Created by Park Junwoo on 11/25/24.
//

struct CampfireTodayImageEmotionResult: Codable {
    let imageId: Int
    let name: String
    let emotions: [Emotion]

    struct Emotion: Codable {
        let memberNickname: String
        let emotion: String
    }
}
