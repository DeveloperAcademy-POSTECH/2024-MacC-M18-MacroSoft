//
//  OrganizePhotoViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation
import SwiftUI
import Photos

class OrganizePhotoViewModel: ObservableObject {
    @Published var currentCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var clusters: [[PhotoMetadata]] = []
    @Published var photoMetadataList: [PhotoMetadata] = []
    @Published var statusMessage: String = "장작을 모으는 중"
    
    private var dbscan = DBSCAN()
    private var timer: Timer?
    private var messageRotationTimer: Timer?
    private var estimatedTimeToComplete: TimeInterval = 0
    
    private let statusMessages = ["장작을 모으는 중", "기억에서 장작 선별중..", "장작의 원산지를 파악중"]

    init() {
        fetchPhotoTotalCount()
    }
    
    private func fetchPhotoTotalCount() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        self.totalCount = fetchResult.count
        self.photoMetadataList = fetchResult.objects(at: IndexSet(0..<fetchResult.count)).map {
            PhotoMetadata(asset: $0, location: nil, creationDate: $0.creationDate)
        }
    }
    
    func applyDBSCAN() {
        // 비동기적으로 DBSCAN 알고리즘 적용
        DispatchQueue.global(qos: .userInitiated).async {
            let resultClusters = self.dbscan.applyAlgorithm(points: self.photoMetadataList) { progress in
                DispatchQueue.main.async {
                    self.currentCount = progress // 알고리즘 진행 상황을 메인 스레드에서 업데이트
                }
            }
            
            // 클러스터링 결과를 메인 스레드에서 업데이트
            DispatchQueue.main.async {
                self.clusters = resultClusters
                print("총 클러스터링된 데이터 개수: \(self.clusters.flatMap { $0 }.count)")
                self.currentCount = self.totalCount // 최종적으로 진행률을 100%로 설정
            }
        }
    }
    
    func startStatusMessageRotation() {
        messageRotationTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
            guard self.currentCount < self.totalCount else { return }
            if let currentIndex = self.statusMessages.firstIndex(of: self.statusMessage) {
                let nextIndex = (currentIndex + 1) % self.statusMessages.count
                self.statusMessage = self.statusMessages[nextIndex]
            }
        }
    }
        
    func stopStatusMessageRotation() {
        messageRotationTimer?.invalidate()
        messageRotationTimer = nil
    }
}

