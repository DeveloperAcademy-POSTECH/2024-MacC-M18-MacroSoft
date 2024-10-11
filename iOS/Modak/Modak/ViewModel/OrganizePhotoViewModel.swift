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
        // 사진이 존재하는지 확인
        guard !photoMetadataList.isEmpty else { return }

        estimatedTimeToComplete = estimateTimeForClustering() // 예상 시간을 계산
        startProgressTimer(duration: estimatedTimeToComplete) // 시각적 진행률 업데이트 시작
        
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
                self.stopProgressTimer() // 알고리즘 완료 시 타이머 중지
                self.currentCount = self.totalCount // 최종적으로 진행률을 100%로 설정
            }
        }
    }
    
    private func estimateTimeForClustering() -> TimeInterval {
        // O(n²) 시간 복잡도를 기반으로 사진 수에 따른 예상 시간 계산 (초 단위)
        let baseTimePerPhoto = 0.01 // 사진 한 장당 기본 처리 시간 (0.01초)
        let estimatedTime = baseTimePerPhoto * pow(Double(totalCount), 2) // O(n²) 예측 모델
        let bufferTime = max(5.0, estimatedTime * 0.1) // 예측 시간의 10% 또는 최소 5초 추가
        return estimatedTime + bufferTime
    }
    
    private func startProgressTimer(duration: TimeInterval) {
        let progressIncrement = 1.0 / duration // 초당 진행률을 계산
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.currentCount < self.totalCount {
                let progressIncrease = Int(Double(self.totalCount) * progressIncrement)
                self.currentCount = min(self.currentCount + progressIncrease, self.totalCount)
            } else {
                self.stopProgressTimer()
            }
        }
    }
    
    private func stopProgressTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startStatusMessageRotation() {
        messageRotationTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
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

