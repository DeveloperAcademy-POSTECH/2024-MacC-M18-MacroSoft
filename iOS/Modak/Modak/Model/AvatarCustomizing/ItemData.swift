//
//  ItemModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import Foundation

struct ItemData {
    let category: String
    let items: [String]
    
    static let sample = [
        ItemData(category: "Top", items: ["nil", "top1", "top2"]),
        ItemData(category: "Hat", items: ["nil", "hat1", "hat2"]),
        ItemData(category: "Face", items: ["nil", "face1", "face2"])
    ]
}
