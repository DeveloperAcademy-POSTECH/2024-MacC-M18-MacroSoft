//
//  MemberAvatar.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

struct MemberAvatar: Codable {
    let memberId: Int
    let nickname: String
    let avatar: MemberItem
}

struct MemberItem: Codable {
    let hatType: Int
    let faceType: Int
    let topType: Int
}
