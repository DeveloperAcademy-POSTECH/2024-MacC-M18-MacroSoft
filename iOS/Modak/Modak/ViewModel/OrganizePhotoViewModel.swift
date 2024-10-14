//
//  OrganizePhotoViewModel.swift
//  Modak
//
//  Created by kimjihee on 10/10/24.
//

import Foundation
import SwiftUI
import Photos
import SwiftData

class OrganizePhotoViewModel: ObservableObject {
    @Published var currentCount: Int = 0
    @Published var totalCount: Int = 0
    @Published var clusters: [[PhotoMetadata]] = []
    @Published var photoMetadataList: [PhotoMetadata] = []
    @Published var statusMessage: String = "장작을 모으는 중"
    @Published var currentCircularProgressPhoto: UIImage? = nil
    
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
        
        fetchResult.enumerateObjects { (asset, _, _) in
            let latitude = asset.location?.coordinate.latitude
            let longitude = asset.location?.coordinate.longitude
            let metadata = PhotoMetadata(localIdentifier: asset.localIdentifier, latitude: latitude, longitude: longitude, creationDate: asset.creationDate)
            self.photoMetadataList.append(metadata)
        }
    }
    
    func applyDBSCAN(completion: @escaping () -> Void) {
        // 비동기적으로 DBSCAN 알고리즘 적용
        DispatchQueue.global(qos: .userInitiated).async {
            let resultClusters = self.dbscan.applyAlgorithm(points: self.photoMetadataList) { progress in
                DispatchQueue.main.async {
                    self.currentCount = progress // 알고리즘 진행 상황을 메인 스레드에서 업데이트
                    self.updateCircularProgressPhoto(currentProgress: progress)
                }
            }
            
            // 클러스터링 결과를 메인 스레드에서 업데이트
            DispatchQueue.main.async {
                self.clusters = resultClusters
                print("총 클러스터링된 데이터 개수: \(self.clusters.flatMap { $0 }.count)")
                self.currentCount = self.totalCount // 최종적으로 진행률을 100%로 설정
                completion() // DBSCAN 완료 시점에 콜백 호출
            }
        }
    }
    
    func startStatusMessageRotation() {
        // 사진 장수에 따라 메시지 변경 시점을 결정
        let changePoints = calculateChangePoints(for: totalCount)
        var currentChangeIndex = 0

        messageRotationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            DispatchQueue.main.async {
                guard self.currentCount < self.totalCount else {
                    self.stopStatusMessageRotation()
                    return
                }
                
                // 현재 진행률이 다음 메시지 변경 지점에 도달했는지 확인
                if currentChangeIndex < changePoints.count && Double(self.currentCount) / Double(self.totalCount) >= changePoints[currentChangeIndex] {
                    let nextIndex = currentChangeIndex % self.statusMessages.count
                    self.statusMessage = self.statusMessages[nextIndex]
                    print("Status Message : \(self.statusMessage)")
                    currentChangeIndex += 1
                }
            }
        }
    }

    private func calculateChangePoints(for totalCount: Int) -> [Double] {
        let numberOfChanges: Int

        // 사진 장수에 따라 메시지 변경 횟수를 설정
        if totalCount <= 5000 {
            numberOfChanges = 3
        } else {
            numberOfChanges = ((totalCount / 5000) * 3)
        }

        // 100%를 변경 횟수로 나누어, 구간 형성. 메시지 변경 지점을 배열로 생성.
        let interval = 1.0 / Double(numberOfChanges)
        return (0...numberOfChanges).map { Double($0) * interval }
    }
        
    func stopStatusMessageRotation() {
        messageRotationTimer?.invalidate()
        messageRotationTimer = nil
    }
    
    private func updateCircularProgressPhoto(currentProgress: Int) {
        let updateFrequency = 600
            
        if currentProgress % updateFrequency == 0 && currentProgress > 0 && currentProgress < photoMetadataList.count {
            let metadata = photoMetadataList[currentProgress]
            fetchPhoto(for: metadata) { image in
                DispatchQueue.main.async {
                    self.currentCircularProgressPhoto = image
                }
            }
        }
    }

    // localIdentifier를 통해 PHAsset을 불러오는 함수
    func fetchPhoto(for metadata: PhotoMetadata, completion: @escaping (UIImage?) -> Void) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [metadata.localIdentifier], options: nil)
        
        guard let asset = fetchResult.firstObject else {
            completion(nil) // 해당하는 사진이 없을 경우
            return
        }
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 213, height: 213), contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
}

