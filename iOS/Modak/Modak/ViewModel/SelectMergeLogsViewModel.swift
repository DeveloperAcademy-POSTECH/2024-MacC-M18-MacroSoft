//
//  SelectMergeLogsViewModel.swift
//  Modak
//
//  Created by Park Junwoo on 11/14/24.
//

import Foundation
import SwiftData

// TODO: DTO 밖으로 빼기
struct CampfireLogsMetadataResponseDTO: Codable {
    var timeStamp: String
    var code: String
    var message: String
    var result: CampfireLogsMetadataResultDTO
}

struct CampfireLogsMetadataResultDTO: Codable {
    var logMetadataList: [CampfireLogMetadata]
}

struct CampfireLogMetadataDTO: Codable {
    var startAt: String
    var endAt: String
    var address: String
    var minLatitude: Double
    var maxLatitude: Double
    var minLongitude: Double
    var maxLongitude: Double
}

class SelectMergeLogsViewModel: ObservableObject{
    @Published var mergeableLogPiles: [MergeableLogPile] = []
    @Published var recommendedMergeableLogPile: MergeableLogPile = MergeableLogPile(isRecommendedLogPile: true, mergeableLogs: [])
    @Published var notRecommendedMergeableLogPile: MergeableLogPile = MergeableLogPile(isRecommendedLogPile: false, mergeableLogs: [])
    
    private var campfireLogsMetadata: [CampfireLogMetadata] = []
    private var currentPage = 1 // 페이지네이션을 위한 페이지 변수
    private var isFetchingPage: Bool = false // fetch 중일 때 중복 호출 막는 변수
    private var isLastPage: Bool = false // 페이지네이션에서 마지막 페이지인지 체크하는 변수
    private let pageSize = 4 // 페이지네이션 당 호출 수
    
    func resetProperties() {
        DispatchQueue.main.async {
            self.mergeableLogPiles = []
            self.recommendedMergeableLogPile = MergeableLogPile(isRecommendedLogPile: true, mergeableLogs: [])
            self.notRecommendedMergeableLogPile = MergeableLogPile(isRecommendedLogPile: false, mergeableLogs: [])
            self.campfireLogsMetadata = []
        }
    }
    
    func getCampfireLogsMetadata(campfirePin: Int) async {
        do {
            let request = try await NetworkManager.shared.requestRawData(router: .getCampfireLogsMetadata(campfirePin: campfirePin))
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let response = try decoder.decode(CampfireLogsMetadataResponseDTO.self, from: request)
            
            campfireLogsMetadata = response.result.logMetadataList
        } catch {
            print("getCampfireLogsMetadata Error: \(error)")
        }
    }
    
    func fetchMergeableLogPiles(modelContext: ModelContext){
        if !isFetchingPage {
            
            isFetchingPage = true
            
            do {
                var descriptor = FetchDescriptor<PrivateLog>()
                // TODO: 추후 페이지네이션 구현을 위한 주석처리
//                descriptor.fetchLimit = pageSize
//                descriptor.fetchOffset = 0
                
                let privateLogs = try modelContext.fetch(descriptor)
                
                if privateLogs.count < pageSize && privateLogs.count > 0 {
                    isLastPage = true
                }
                
                convertToMergeableLogPiles(privateLogs: privateLogs)
                
                isFetchingPage = false
            } catch {
                print("fetchLogsWithGroupBy failed: \(error)")
                isFetchingPage = false
            }
        }
    }
    
    private func checkLogMetadataOverlap(privateLog: PrivateLog, campfireLogMetadata: CampfireLogMetadata) -> Bool {
        
        // 위치 겹침 조건
        let isLocationOverlap = privateLog.maxLatitude >= campfireLogMetadata.minLatitude &&
        privateLog.minLatitude <= campfireLogMetadata.maxLatitude &&
        privateLog.maxLongitude >= campfireLogMetadata.minLongitude &&
        privateLog.minLongitude <= campfireLogMetadata.maxLongitude
        
        // 시간 겹침 조건
        let isTimeOverlap = privateLog.endAt >= campfireLogMetadata.startAt.iso8601ToDate &&
        privateLog.startAt <= campfireLogMetadata.endAt.iso8601ToDate
        
        return isLocationOverlap && isTimeOverlap
    }
    
    private func convertToMergeableLogPiles(privateLogs: [PrivateLog]) {
        
        if campfireLogsMetadata.isEmpty {
            for privateLog in privateLogs {
                let mergeableLog = MergeableLog(
                    id: privateLog.id,
                    minLatitude: privateLog.minLatitude,
                    maxLatitude: privateLog.maxLatitude,
                    minLongitude: privateLog.minLongitude,
                    maxLongitude: privateLog.maxLongitude,
                    startAt: privateLog.startAt,
                    endAt: privateLog.endAt,
                    images: privateLog.sortedImages,
                    address: privateLog.address
                )
                
                notRecommendedMergeableLogPile.mergeableLogs.append(mergeableLog)
            }
            
            mergeableLogPiles = [notRecommendedMergeableLogPile]
        } else {
            for privateLog in privateLogs {
                for campfireLogMetadata in campfireLogsMetadata {
                    
                    let mergeableLog = MergeableLog(
                        id: privateLog.id,
                        minLatitude: privateLog.minLatitude,
                        maxLatitude: privateLog.maxLatitude,
                        minLongitude: privateLog.minLongitude,
                        maxLongitude: privateLog.maxLongitude,
                        startAt: privateLog.startAt,
                        endAt: privateLog.endAt,
                        images: privateLog.sortedImages,
                        address: privateLog.address
                    )
                    
                    if checkLogMetadataOverlap(privateLog: privateLog, campfireLogMetadata: campfireLogMetadata) {
                        recommendedMergeableLogPile.mergeableLogs.append(mergeableLog)
                        break
                    } else {
                        if campfireLogMetadata == campfireLogsMetadata.last {
                            notRecommendedMergeableLogPile.mergeableLogs.append(mergeableLog)
                        }
                    }
                }
            }
            mergeableLogPiles = [recommendedMergeableLogPile, notRecommendedMergeableLogPile]
        }
    }
}
