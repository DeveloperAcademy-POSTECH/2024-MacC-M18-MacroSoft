//
//  MergeableLogImage.swift
//  Modak
//
//  Created by Park Junwoo on 11/13/24.
//

import Foundation

struct MergeableLogImage {
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
