//
//  Campfire.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//

import Foundation
import SwiftData

@Model
class Campfire {
    @Attribute(.unique) var id: Int64
    var title: String
    var todayImage: PublicLogImage?
    var pin: Int
    
    init(id: Int64, title: String, todayImage: PublicLogImage? = nil, pin: Int) {
        self.id = id
        self.title = title
        self.todayImage = todayImage
        self.pin = pin
    }
}
