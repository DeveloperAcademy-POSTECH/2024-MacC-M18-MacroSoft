struct MemberAvatar: Codable {
    let memberId: Int
    let nickname: String
    let avatar: AvatarInfo
}

struct AvatarInfo: Codable {
    let hatType: Int
    let faceType: Int
    let topType: Int
}