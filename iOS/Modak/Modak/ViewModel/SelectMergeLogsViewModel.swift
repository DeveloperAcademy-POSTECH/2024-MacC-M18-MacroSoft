//
//  SelectMergeLogsViewModel.swift
//  Modak
//
//  Created by Park Junwoo on 11/14/24.
//

import SwiftData
import SDWebImageWebPCoder
import Photos

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

struct PresignedURLResponseDTO: Codable {
    var timeStamp: String
    var code: String
    var message: String
    var result: PresignedURLResultDTO
}

struct PresignedURLResultDTO: Codable {
    var url: String
}

struct UploadCampfireLogsResponseDTO: Codable {
    var timeStamp: String
    var code: String
    var message: String
    var result: [String: Int]
}

struct UploadCampfireLogsBodyDTO: Codable {
    var logMetadata: CampfireLogMetadata
    var imageInfos: [UploadCampfireLogsImageInfoDTO]
}

struct UploadCampfireLogsImageInfoDTO: Codable {
    var imageName: String
    var latitude: Double
    var longitude: Double
    var takenAt: String
}

class SelectMergeLogsViewModel: ObservableObject{
    @Published var mergeableLogPiles: [MergeableLogPile] = []
    @Published var recommendedMergeableLogPile: MergeableLogPile = MergeableLogPile(isRecommendedLogPile: true, mergeableLogs: [])
    @Published var notRecommendedMergeableLogPile: MergeableLogPile = MergeableLogPile(isRecommendedLogPile: false, mergeableLogs: [])
    @Published var isUploadCampfireLogsLoading: Bool = false
    
    private var campfireLogsMetadata: [CampfireLogMetadata] = []
    private var currentPage = 1 // 페이지네이션을 위한 페이지 변수
    private var isFetchingPage: Bool = false // fetch 중일 때 중복 호출 막는 변수
    private var isLastPage: Bool = false // 페이지네이션에서 마지막 페이지인지 체크하는 변수
    private let pageSize = 4 // 페이지네이션 당 호출 수
    private var presignedURL: String = ""
    
    // MARK: - resetProperties: SelectMergeLogsViewModel의 프로퍼티를 초기화하는 메서드
    func resetProperties() {
        DispatchQueue.main.async {
            self.mergeableLogPiles = []
            self.recommendedMergeableLogPile = MergeableLogPile(isRecommendedLogPile: true, mergeableLogs: [])
            self.notRecommendedMergeableLogPile = MergeableLogPile(isRecommendedLogPile: false, mergeableLogs: [])
            self.campfireLogsMetadata = []
        }
    }
    
    // MARK: - getCampfireLogsMetadata: 서버에서 해당 캠프파이어의 로그 메타데이터를 가져오는 메서드
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
    
    // MARK: - fetchMergeableLogPiles: PrivateLog들을 가져오는 메서드
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
                print("fetchMergeableLogPiles failed: \(error)")
                isFetchingPage = false
            }
        }
    }
    
    // MARK: - checkLogMetadataOverlap: PrivateLog의 메타데이터와 캠프파이어의 로그 메타데이터를 비교해서 추천 장작을 구분하는 메서드
    private func checkLogMetadataOverlap(privateLog: PrivateLog, campfireLogMetadata: CampfireLogMetadata) -> Bool {
        
        // 위치 겹침 조건
        let isLocationOverlap = privateLog.maxLatitude.roundToDecimalPlaces(6) >= campfireLogMetadata.minLatitude &&
        privateLog.minLatitude.roundToDecimalPlaces(6) <= campfireLogMetadata.maxLatitude &&
        privateLog.maxLongitude.roundToDecimalPlaces(6) >= campfireLogMetadata.minLongitude &&
        privateLog.minLongitude.roundToDecimalPlaces(6) <= campfireLogMetadata.maxLongitude
        
        // 시간 겹침 조건
        let isTimeOverlap = privateLog.endAt >= campfireLogMetadata.startAt.iso8601ToDate &&
        privateLog.startAt <= campfireLogMetadata.endAt.iso8601ToDate
        
        return isLocationOverlap && isTimeOverlap
    }
    
    // MARK: - convertToMergeableLogPiles: PrivateLog들을 파싱해서 MergeableLogPile들에 담는 메서드
    private func convertToMergeableLogPiles(privateLogs: [PrivateLog]) {
        
        if campfireLogsMetadata.isEmpty {
            notRecommendedMergeableLogPile.mergeableLogs = privateLogs.map {
                MergeableLog(
                    id: $0.id,
                    minLatitude: $0.minLatitude,
                    maxLatitude: $0.maxLatitude,
                    minLongitude: $0.minLongitude,
                    maxLongitude: $0.maxLongitude,
                    startAt: $0.startAt,
                    endAt: $0.endAt,
                    images: $0.sortedImages,
                    address: $0.address
                )
            }
            mergeableLogPiles = [notRecommendedMergeableLogPile]
            return
        }

        // 중복 방지를 위한 Set
        var recommendedLogIDs = Set<UUID>()
        var notRecommendedLogIDs = Set<UUID>()

        // privateLogs 순회
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

            // 추천 그룹 확인
            var isRecommended = false
            for campfireLogMetadata in campfireLogsMetadata {
                if checkLogMetadataOverlap(privateLog: privateLog, campfireLogMetadata: campfireLogMetadata) {
                    if !recommendedLogIDs.contains(privateLog.id) {
                        recommendedMergeableLogPile.mergeableLogs.append(mergeableLog)
                        recommendedLogIDs.insert(privateLog.id)
                    }
                    isRecommended = true
                    break
                }
            }

            // 비추천 그룹 추가
            if !isRecommended, !notRecommendedLogIDs.contains(privateLog.id) {
                notRecommendedMergeableLogPile.mergeableLogs.append(mergeableLog)
                notRecommendedLogIDs.insert(privateLog.id)
            }
        }

        // mergeableLogPiles 업데이트
        if recommendedMergeableLogPile.mergeableLogs.isEmpty {
            mergeableLogPiles = [notRecommendedMergeableLogPile]
        } else {
            mergeableLogPiles = [recommendedMergeableLogPile, notRecommendedMergeableLogPile]
        }
    }
    
    // MARK: - updateCampfireLogs: 캠프파이어에 로그를 업데이트(업로드)하는 메서드
    func updateCampfireLogs(campfirePin: Int) async {
        // TODO: 차라리 isSelectedLog들을 담아두는 @Published 변수를 하나 만드는 것도 괜찮을지도?
        let selectedLogs = mergeableLogPiles.flatMap { $0.mergeableLogs.filter { $0.isSelectedLog } }
        var uploadLogs: [UploadCampfireLogsBodyDTO] = []
        
        for selectedLog in selectedLogs {
            var uploadLog: UploadCampfireLogsBodyDTO = .init(logMetadata: .init(startAt: selectedLog.startAt.ISO8601Format(), endAt: selectedLog.endAt.ISO8601Format(), address: selectedLog.address.checkAddressNilAndEmpty(), minLatitude: selectedLog.minLatitude, maxLatitude: selectedLog.maxLatitude, minLongitude: selectedLog.minLongitude, maxLongitude: selectedLog.maxLongitude), imageInfos: [])
            for metadata in selectedLog.images {
                var uploadLogImage: UploadCampfireLogsImageInfoDTO = .init(imageName: "", latitude: metadata.latitude ?? 0, longitude: metadata.longitude ?? 0, takenAt: metadata.creationDate?.ISO8601Format() ?? Date().ISO8601Format())
                await getPresignedURL()
                let webpData = await convertImageToWebpData(metadata: metadata)
                let urlName = await uploadWebpImageData(webpImageData: webpData)
                if let imageURLName = urlName {
                    uploadLogImage.imageName = imageURLName
                    uploadLog.imageInfos.append(uploadLogImage)
                }
            }
            uploadLogs.append(uploadLog)
        }
        await uploadCampfireLogs(campfirePin: campfirePin, selectedLogs: uploadLogs)
        DispatchQueue.main.async {
            self.isUploadCampfireLogsLoading = false
        }
    }
    
    // MARK: - getPresignedURL: 서버에서 이미지데이터를 올릴 PresignedURL을 받아오는 메서드
    private func getPresignedURL() async {
        do {
            let request = try await NetworkManager.shared.requestRawData(router: .getPresignedURL(fileExtension: "webp"))
            
            let decoder = JSONDecoder()
            
            let response = try decoder.decode(PresignedURLResponseDTO.self, from: request)
            
            presignedURL = response.result.url
        } catch {
            print("getPresignedURL error: \(error)")
        }
    }
    
    // MARK: - convertImageToWebpData: 앨범의 이미지를 불러와서, UIImage를 WebpData로 바꾸는 메서드
    private func convertImageToWebpData(metadata: PrivateLogImage) async -> Data? {
        var uiImage: UIImage?
        
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [metadata.localIdentifier], options: nil)
        
        guard let asset = fetchResult.firstObject else {
            return nil
        }
        
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: .init(width: 1920, height: 1920), contentMode: .aspectFit, options: options) { img, _ in
            uiImage = img
        }
        
        let webPCoder = SDImageWebPCoder.shared
        if let image = uiImage , let wepbData = webPCoder.encodedData(with: image, format: .webP, options: nil) {
            return wepbData
        } else {
            return nil
        }
    }
    
    // MARK: - uploadWebpImageData: WebpData를 S3에 업로드하는 메서드
    private func uploadWebpImageData(webpImageData: Data?) async -> String? {
        var imageURLName: String?
        
        do {
            if let presignedURL = URL(string: presignedURL), let webpImageData = webpImageData {
                var request = URLRequest(url: presignedURL)
                request.httpMethod = "PUT"
                request.httpBody = webpImageData
                
                let (_, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    print("uploadWebpImageData response code: \(response)")
                    throw NetworkError.serverError
                }
                
                imageURLName = self.presignedURL.webpURLName
            } else {
                print("uploadWebpImageData url error: \(presignedURL) \n webpImageData == nil: \(webpImageData == nil)")
            }
        } catch {
            print("uploadWebpImageData error: \(error)")
        }
        print("uploadWebpImageData imageURLName: \(imageURLName ?? "nil")")
        return imageURLName
    }
    
    // MARK: - uploadCampfireLogs: 캠프파이어에 로그를 업로드하는 API 통신 실 구현 메서드
    private func uploadCampfireLogs(campfirePin: Int, selectedLogs: [UploadCampfireLogsBodyDTO]) async {
        
        for selectedLog in selectedLogs {
            do {
                let request = try await NetworkManager.shared.requestRawData(router: .updateCampfireLogs(campfirePin: campfirePin, parameters: selectedLog.toDictionary()!))
                
                let decoder = JSONDecoder()
                
                let response = try decoder.decode(UploadCampfireLogsResponseDTO.self, from: request)
                
                print("uploadCampfireLogs response: \(response)")
            } catch {
                print("uploadCampfireLogs error: \(error)")
            }
        }
        
    }
}

// MARK: - toDictionary: 주어진 딕셔너리를 [String: Any] 형태로 변환하는 extension
extension Encodable {
    func toDictionary() -> [String: Any]? {
        do {
            let jsonData = try JSONEncoder().encode(self)
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return dictionary
        } catch {
            print("Error converting to dictionary: \(error)")
            return nil
        }
    }
}
