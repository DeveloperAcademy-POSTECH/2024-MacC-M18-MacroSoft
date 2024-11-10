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
    var image: String? // TODO: PublicLogImage 모델로 교체, codable 준수.
    var membersNames: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "campfireName"
        case pin = "campfirePin"
        case image // 현재 실제 DB값과 다르게 설정해놔서, 연결 안되어있음.
        case membersNames
    }

    init(name: String, pin: Int, image: String? = "", membersNames: [String] = []) {
        self.name = name
        self.pin = pin
        self.image = image
        self.membersNames = membersNames
    }
    
    // Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.pin = try container.decode(Int.self, forKey: .pin)
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.membersNames = try container.decodeIfPresent([String].self, forKey: .membersNames) ?? []
    }
    
    // Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(pin, forKey: .pin)
        try container.encodeIfPresent(image, forKey: .image)
        try container.encode(membersNames, forKey: .membersNames)
    }
}

