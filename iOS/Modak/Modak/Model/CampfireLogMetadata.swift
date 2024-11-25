//
//  CampfireLogMetadata.swift
//  Modak
//
//  Created by Park Junwoo on 11/14/24.
//

import Foundation

struct CampfireLogMetadata: Codable, Equatable {
    var startAt: String
    var endAt: String
    var address: String
    var minLatitude: Double
    var maxLatitude: Double
    var minLongitude: Double
    var maxLongitude: Double
    
    enum CodingKeys: String, CodingKey {
        case startAt
        case endAt
        case address
        case minLatitude
        case maxLatitude
        case minLongitude
        case maxLongitude
    }

    // Equatable 프로토콜을 위한 == 연산자 구현
    static func ==(lhs: CampfireLogMetadata, rhs: CampfireLogMetadata) -> Bool {
        return lhs.startAt == rhs.startAt &&
               lhs.endAt == rhs.endAt &&
               lhs.address == rhs.address &&
               lhs.minLatitude == rhs.minLatitude &&
               lhs.maxLatitude == rhs.maxLatitude &&
               lhs.minLongitude == rhs.minLongitude &&
               lhs.maxLongitude == rhs.maxLongitude
    }
}
