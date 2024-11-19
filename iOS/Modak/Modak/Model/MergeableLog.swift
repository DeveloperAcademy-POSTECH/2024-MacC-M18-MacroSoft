//
//  MergeableLog.swift
//  Modak
//
//  Created by Park Junwoo on 11/13/24.
//

import Foundation

struct MergeableLog {
    var id: UUID
    var isSelectedLog: Bool
    
    var minLatitude: Double
    var maxLatitude: Double
    var minLongitude: Double
    var maxLongitude: Double
    var startAt: Date
    var endAt: Date
    var images: [PrivateLogImage]
    var address: String?
    
    init(id: UUID, minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, startAt: Date, endAt: Date, images: [PrivateLogImage], address: String? = nil) {
        self.id = id
        self.isSelectedLog = false
        self.minLatitude = minLatitude
        self.maxLatitude = maxLatitude
        self.minLongitude = minLongitude
        self.maxLongitude = maxLongitude
        self.startAt = startAt
        self.endAt = endAt
        self.images = images
        self.address = address
    }
}
