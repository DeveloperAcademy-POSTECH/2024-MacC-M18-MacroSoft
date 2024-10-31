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
    @Attribute(.unique) var id: UUID
    var campfireId: Int
    var locationId: Int
    var startAt: Date
    var endAt: Date
    
    init(id: UUID, campfireId: Int, locationId: Int, startAt: Date, endAt: Date) {
        self.id = id
        self.campfireId = campfireId
        self.locationId = locationId
        self.startAt = startAt
        self.endAt = endAt
    }
}
