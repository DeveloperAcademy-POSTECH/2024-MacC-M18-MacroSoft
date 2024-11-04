//
//  PublicLogImage.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//

import Foundation
import SwiftData

@Model
class PublicLogImage {
    @Attribute(.unique) var id: Int64
    var name: String // URL에서 .com/ 이후 값 저장
    var latitude: Double
    var longitude: Double
    var creationDate: Date
    var userEmotions: [UserEmotion]
    
    init(id: Int64, name: String, latitude: Double, longitude: Double, creationDate: Date, userEmotions: [UserEmotion]) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.creationDate = creationDate
        self.userEmotions = userEmotions
    }
}

struct UserEmotion: Codable {
    var userName: String
    var emotion: String
}
