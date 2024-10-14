//
//  PhotoMetadata.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation
import Photos
import SwiftUI

class PhotoMetadata: Identifiable, Hashable {
    var id: UUID = UUID()
    var asset: PHAsset
    var localIdentifier: String
    var location: CLLocation?
    var creationDate: Date?
    
    init(asset: PHAsset, localIdentifier: String, location: CLLocation?, creationDate: Date?) {
        self.asset = asset
        self.localIdentifier = localIdentifier
        self.location = location
        self.creationDate = creationDate
    }
    
    // Hashable 프로토콜을 구현하기 위한 메서드
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // id로 고유 해시 생성
    }
    
    // Equatable 프로토콜을 구현하기 위한 메서드
    static func == (lhs: PhotoMetadata, rhs: PhotoMetadata) -> Bool {
        return lhs.id == rhs.id
    }
}

