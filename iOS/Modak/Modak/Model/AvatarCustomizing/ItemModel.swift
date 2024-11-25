//
//  ItemModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import Foundation

struct ItemModel {
    let category: String
    let items: [String]
    
    static let sample = [
        ItemModel(category: "Top", items: ["nil", "top1", "top2"]),
        ItemModel(category: "Hat", items: ["nil", "hat1", "hat2"]),
        ItemModel(category: "Face", items: ["nil", "face1", "face2"])
    ]
}
