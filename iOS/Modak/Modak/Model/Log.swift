//
//  Log.swift
//  Modak
//
//  Created by kimjihee on 10/14/24.
//

import Foundation
import SwiftData
import CoreLocation

@Model
class Log {
    @Attribute(.unique) var id: UUID
    var minLatitude: Double
    var maxLatitude: Double
    var minLongitude: Double
    var maxLongitude: Double
    var startAt: Date
    var endAt: Date
    var images: [PhotoMetadata] // 클러스터링된 PhotoMetadata 배열

    init(minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, startAt: Date, endAt: Date, images: [PhotoMetadata]) {
        self.id = UUID()
        self.minLatitude = minLatitude
        self.maxLatitude = maxLatitude
        self.minLongitude = minLongitude
        self.maxLongitude = maxLongitude
        self.startAt = startAt
        self.endAt = endAt
        self.images = images
    }
}
