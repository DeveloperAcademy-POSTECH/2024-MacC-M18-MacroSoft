//
//  CampfireLogImagesResult.swift
//  Modak
//
//  Created by Park Junwoo on 11/26/24.
//

import SwiftUI

struct CampfireLogImagesResult: Codable {
    var logId: Int
    var images: [CampfireLogImage]
    var hasNext: Bool
}

struct CampfireLogImagesData: Codable {
    var logId: Int
    var images: [CampfireLogImage]
    var hasNext: Bool
    var currentPage: Int
}

struct CampfireLogImage: Codable {
    var imageId: Int
    var imageName: String
}
