//
//  CampfireLogsInfosResult.swift
//  Modak
//
//  Created by Park Junwoo on 11/25/24.
//

struct CampfireLogsInfosResult: Codable {
    var campfireInfos: [CampfireInfo]
}

struct CampfireInfo: Codable {
    var campfirePin: Int
    var campfireName: String
    var membersNames: [String]
    var memberIds: [Int]
    var imageName: String?
}
struct MainCampfireInfo: Codable, Equatable {
    static func == (lhs: MainCampfireInfo, rhs: MainCampfireInfo) -> Bool {
        // TODO: todayImage 프로퍼티 비교까지 하면 번거로워져서 제외
        return lhs.campfirePin == rhs.campfirePin &&
        lhs.campfireName == rhs.campfireName &&
        lhs.memberIds == rhs.memberIds
    }
    
    var campfirePin: Int
    var campfireName: String
    var todayImage: TodayImage
    var memberIds: [Int]
}
