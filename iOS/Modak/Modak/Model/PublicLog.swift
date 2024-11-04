//
//  PublicLog.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//
import Foundation
import SwiftData

@Model
class PublicLog {
    @Attribute(.unique) var id: Int64
    var campfireId: Int64
    var locationId: Int64
    var startAt: Date
    var endAt: Date
    
    init(id: Int64, campfireId: Int64, locationId: Int64, startAt: Date, endAt: Date) {
        self.id = id
        self.campfireId = campfireId
        self.locationId = locationId
        self.startAt = startAt
        self.endAt = endAt
    }
}
