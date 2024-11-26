//
//  CampfireLogImageDetailResult.swift
//  Modak
//
//  Created by Park Junwoo on 11/26/24.
//

import SwiftUI

struct CampfireLogImageDetailResult: Codable {
    var imageId: Int
    var imageName: String
    var latitude: Double
    var longitude: Double
    var takenAt: String
    var memberNickname: String
    var logId: Int
    var emotions: [Emotion]
}
