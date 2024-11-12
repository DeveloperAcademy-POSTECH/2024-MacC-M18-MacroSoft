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
    var images: [MergeableLogImage]
    var address: String?
    
    init(isSelectedLog: Bool, minLatitude: Double, maxLatitude: Double, minLongitude: Double, maxLongitude: Double, startAt: Date, endAt: Date, images: [MergeableLogImage], address: String? = nil) {
        self.id = UUID()
        self.isSelectedLog = isSelectedLog
        self.minLatitude = minLatitude
        self.maxLatitude = maxLatitude
        self.minLongitude = minLongitude
        self.maxLongitude = maxLongitude
        self.startAt = startAt
        self.endAt = endAt
        self.images = images
        self.address = address
    }
    
    static var testSelectedMergeableLog: MergeableLog {
        .init(isSelectedLog: true, minLatitude: 0, maxLatitude: 0, minLongitude: 0, maxLongitude: 0, startAt: Date(), endAt: Date(), images: [MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()), MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()), MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()),MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()),MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()),MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()),MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()),MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date())])
    }
    
    static var testNotSelectedMergeableLog: MergeableLog {
        .init(isSelectedLog: false, minLatitude: 0, maxLatitude: 0, minLongitude: 0, maxLongitude: 0, startAt: Date(), endAt: Date(), images: [MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date()), MergeableLogImage(localIdentifier: "\(UUID())", latitude: 0, longitude: 0, creationDate: Date())])
    }
}
