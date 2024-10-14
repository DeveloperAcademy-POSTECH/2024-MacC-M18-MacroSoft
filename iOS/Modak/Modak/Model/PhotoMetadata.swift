//
//  PhotoMetadata.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation
import Photos
import SwiftData
import CoreLocation

@Model
class PhotoMetadata {
    @Attribute(.unique) var localIdentifier: String // 고유 식별자
    var latitude: Double?
    var longitude: Double?
    var creationDate: Date?
    
    init(localIdentifier: String, latitude: Double?, longitude: Double?, creationDate: Date?) {
        self.localIdentifier = localIdentifier
        self.latitude = latitude
        self.longitude = longitude
        self.creationDate = creationDate
    }
}
