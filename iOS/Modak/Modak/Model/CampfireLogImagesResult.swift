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
}

struct CampfireLogImage: Codable {
    var imageId: Int
    var imageName: String
}
