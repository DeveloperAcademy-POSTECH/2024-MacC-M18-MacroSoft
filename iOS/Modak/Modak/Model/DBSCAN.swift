//
//  DBSCAN.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation

class DBSCAN {
    var eps: TimeInterval // 최대 시간 차이 (초 단위)
    var minPts: Int // 최소 포인트 수

    init(eps: TimeInterval = 10800, minPts: Int = 10) { // 기본값 설정
        self.eps = eps
        self.minPts = minPts
    }
    
    func changeMinPts(_ minPts: String) {
        self.minPts = Int(minPts) ?? 10
    }
    
    func changeMaxDis(_ maxDis: String) {
        self.eps = TimeInterval(maxDis) ?? 10800
    }

    func applyAlgorithm(points: [PhotoMetadata], progressUpdate: (Int) -> Void) -> [[PhotoMetadata]] {
        var clusters: [[PhotoMetadata]] = []
        var visited = Set<PhotoMetadata>()
        var noise: [PhotoMetadata] = []
        var processedPoints = 0
        
        func regionQuery(point: PhotoMetadata) -> [PhotoMetadata] {
            return points.filter { timeDifference($0.creationDate, point.creationDate) < eps }
        }
        
        func expandCluster(point: PhotoMetadata, neighbors: [PhotoMetadata], cluster: inout [PhotoMetadata]) {
            cluster.append(point)
            var queue = neighbors
            while !queue.isEmpty {
                let neighbor = queue.removeFirst()
                if !visited.contains(neighbor) { // 방문하지 않은 포인트만 처리
                    visited.insert(neighbor)
                    let newNeighbors = regionQuery(point: neighbor)
                    if newNeighbors.count >= minPts {
                        queue.append(contentsOf: newNeighbors)
                    }
                }
                if !cluster.contains(neighbor) {
                    cluster.append(neighbor)
                }
            }
        }
        
        for point in points {
            // 방문 여부에 관계없이 일단 모든 포인트를 처리하도록 변경
            if !visited.contains(point) {
                visited.insert(point)
                let neighbors = regionQuery(point: point)
                if neighbors.count < minPts {
                    noise.append(point)  // 클러스터링 되지 않는 포인트는 노이즈로 추가
                } else {
                    var cluster: [PhotoMetadata] = []
                    expandCluster(point: point, neighbors: neighbors, cluster: &cluster)
                    clusters.append(cluster)
                }
            }
        
            // 진행 상황 업데이트: 모든 포인트에 대해 업데이트되도록 보장
            processedPoints += 1
            progressUpdate(processedPoints)
//            print("Main Loop - Processing photo \(processedPoints) out of \(points.count)")
        }
        
        print("Total clusters formed: \(clusters.count)")
        return clusters
    }
    
    // 시간 간의 차이 계산
    private func timeDifference(_ date1: Date?, _ date2: Date?) -> TimeInterval {
        guard let date1 = date1, let date2 = date2 else { return Double.infinity }
        return abs(date1.timeIntervalSince(date2))
    }
}
