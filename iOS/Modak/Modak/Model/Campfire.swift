//
//  Campfire.swift
//  Modak
//
//  Created by Park Junwoo on 10/31/24.
//

import Foundation
import SwiftData

@Model
class Campfire: Codable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var pin: Int
    var todayImage: TodayImage
    var imageName: String?
    var membersNames: [String]
    var memberIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "campfireName"
        case pin = "campfirePin"
        case todayImage
        case imageName
        case membersNames
        case memberIds
    }
    
    init(name: String, pin: Int, todayImage: TodayImage, imageName: String?, membersNames: [String] = [], memberIds: [Int] = []) {
        self.name = name
        self.pin = pin
        self.todayImage = todayImage
        self.membersNames = membersNames
        self.memberIds = memberIds
        self.imageName = imageName
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.pin = try container.decode(Int.self, forKey: .pin)
        self.todayImage = try container.decodeIfPresent(TodayImage.self, forKey: .todayImage) ?? .init(imageId: 0, name: "", emotions: [])
        self.imageName = try container.decodeIfPresent(String.self, forKey: .imageName) ?? ""
        self.membersNames = try container.decodeIfPresent([String].self, forKey: .membersNames) ?? []
        self.memberIds = try container.decodeIfPresent([Int].self, forKey: .memberIds) ?? []
    }
    
    // Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(pin, forKey: .pin)
        try container.encode(todayImage, forKey: .id)
        try container.encodeIfPresent(imageName, forKey: .imageName)
        try container.encode(membersNames, forKey: .membersNames)
    }
}

