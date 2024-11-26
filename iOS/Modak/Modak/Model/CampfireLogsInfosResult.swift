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
struct MainCampfireInfo: Codable {
    
    var campfirePin: Int
    var campfireName: String
    var todayImage: TodayImage
    var memberIds: [Int]
}
