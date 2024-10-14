//
//  PhotoMetadata.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation
import Photos
import SwiftData

@Model
class PhotoMetadata {
    var localIdentifier: String // 고유 식별자
    var latitude: Double?
    var longitude: Double?
    var creationDate: Date?
    
    init(localIdentifier: String, latitude: Double?, longitude: Double?, creationDate: Date?) {
        guard !localIdentifier.isEmpty else {
            fatalError("localIdentifier는 필수 값입니다.")
        }
        self.localIdentifier = localIdentifier
        self.latitude = latitude
        self.longitude = longitude
        self.creationDate = creationDate
    }
}
