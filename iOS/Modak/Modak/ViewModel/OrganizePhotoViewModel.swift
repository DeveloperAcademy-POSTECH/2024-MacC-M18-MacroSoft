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
    
    private var dbscan = DBSCAN()

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
            self.clusters = self.dbscan.applyAlgorithm(points: self.photoMetadataList) { progress in
                DispatchQueue.main.async {
                    self.currentCount = progress // 알고리즘 진행 상황 업데이트
                }
            }
        }
    }
}

