//
//  CampfireViewModel.swift
//  Modak
//
//  Created by kimjihee on 11/6/24.
//

import SwiftUI
import Combine
import SDWebImageWebPCoder

class CampfireViewModel: ObservableObject {
    @Published var mainCampfireInfo: MainCampfireInfo? // 단일 데이터
    @Published var myCampfireInfos: [CampfireInfo] = [] // 데이터 묶음
    @Published var isEmotionRequest: Bool = false
    
    // TODO: 제거하기
    @Published var currentCampfire: Campfire? // 단일 데이터
    // TODO: 제거하기
    @Published var myCampfires: [Campfire] = [] // 데이터 묶음
    // TODO: 제거하기
    @Published var isEmptyCampfire: Bool = true
    // TODO: 제거하기
    @AppStorage("recentVisitedCampfirePin") var recentVisitedCampfirePin: Int = 0
    
    @Published var showNetworkAlert: Bool = false
    @Published var showEmptyLogAlert: Bool = false
    @Published var currentCampfirePin: Int = 0
    @Published var mainTodayImageURL: URL?
    @Published var currentCampfireYearlyLogs: YearlyLogsOverview = .init(hasNext: false, currentPage: 0, monthlyLogs: [])
    @Published var currentCampfireLogImagesData: CampfireLogImagesData = .init(logId: 0, images: [], hasNext: false, currentPage: 0)
    @Published var currentCampfireLogImageDetail: CampfireLogImageDetailResult?
    
    //    init() {
    //        fetchCampfireMainInfo()
    //    }
    
    @MainActor
    func testChangeCurrentCampfirePin(_ pin: Int) async {
        self.currentCampfirePin = pin
    }
    
    func testFetchCampfireInfos() async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .getMyCampfires)
            let result = try JSONDecoder().decode(ResponseModel<CampfireLogsInfosResult>.self, from: response).result
            
            DispatchQueue.main.async {
                self.myCampfireInfos = result.campfireInfos
                if self.currentCampfirePin == 0 {
                    self.currentCampfirePin = result.campfireInfos.first?.campfirePin ?? 0
                }
            }
            
        } catch {
            print("testfetchCampfireInfos error: \(error)")
        }
    }
    
    func testFetchMainCampfireInfo() async {
        do {
            if currentCampfirePin != 0 {
                let response = try await NetworkManager.shared.requestRawData(router: .getCampfireMainInfo(campfirePin: currentCampfirePin))
                
                let result = try JSONDecoder().decode(ResponseModel<MainCampfireInfo>.self, from: response).result
                DispatchQueue.main.async {
                    self.mainCampfireInfo = result
                }
            } else {
                print("testfetchCampfireMainInfo currentCampfirePin == 0")
            }
        } catch {
            print("testfetchCampfireMainInfo error: \(error)")
        }
    }
    
    func testCreateCampfire(newCampfireName: String) async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .createCampfire(campfireName: newCampfireName))
            
            let result = try JSONDecoder().decode(ResponseModel<[String: Int]>.self, from: response)
            
            if let newCampfirePin = result.result.first?.value {
                await testChangeCurrentCampfirePin(newCampfirePin)
            }
            
            print("testCreateCampfire result: \(result)")
            
            Task {
                await testFetchCampfireInfos()
                await testFetchMainCampfireInfo()
                DispatchQueue.main.async {
                    self.mainTodayImageURL = nil
                }
            }
        } catch {
            print("testCreateCampfire error: \(error)")
        }
    }
    
    @MainActor
    func testFetchCampfireLogsPreview() async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .getCampfireLogsPreview(campfirePin: currentCampfirePin, parameters: [:]))
            
            let result = try JSONDecoder().decode(ResponseModel<CampfireLogsPreviewResult>.self, from: response).result
            
            if !result.logOverviews.isEmpty {
                // logs: [Log]를, monthlyLogs(MonthlyLogs Model과는 다름): [Date : [Log]] 형태로 (년, 월 기준으로)
                let monthlyLogs = Dictionary(grouping: result.logOverviews) { log in
                    let components = Calendar.current.dateComponents([.year, .month], from: log.startAt.iso8601ToDate)
                    return Calendar.current.date(from: components)!
                }
                
                // YearlyLogs를 최신 순으로 정렬하고, 각 월 안에서 다시 일별로 그룹화
                currentCampfireYearlyLogs.monthlyLogs = monthlyLogs.sorted { $0.key > $1.key } // 최신 월 순으로 정렬
                    .map { (month, logsInMonth) in
                        // 같은 월 안에서 다시 일별로 그룹화
                        let dailyLogs = Dictionary(grouping: logsInMonth) { log in
                            Calendar.current.startOfDay(for: log.startAt.iso8601ToDate) // 일 단위로 그룹화
                        }
                        
                        // 날짜별 로그들을 최신 날짜 순으로 정렬
                        let sortedDailyLogs = dailyLogs.sorted { $0.key > $1.key }
                            .map { (day, logsInDay) in
                                DailyLogsOverview(date: day, logs: logsInDay.sorted { $0.startAt.iso8601ToDate > $1.startAt.iso8601ToDate }) // 시간순으로 정렬
                            }
                        
                        // 월 단위로 묶고, 그 안에 일별로 묶인 로그들 포함
                        return MonthlyLogsOverview(date: month, dailyLogs: sortedDailyLogs)
                    }
                currentCampfireYearlyLogs.hasNext = result.hasNext
                currentCampfireYearlyLogs.currentPage += 1
            }
        } catch {
            print("testFetchCampfireLogsPreview error: \(error)")
        }
    }
    
    @MainActor
    func testFetchMoreCampfireLogsPreview() {
        if currentCampfireYearlyLogs.hasNext {
            Task {
                do {
                    let response = try await NetworkManager.shared.requestRawData(router: .getCampfireLogsPreview(campfirePin: currentCampfirePin, parameters: ["page" : currentCampfireYearlyLogs.currentPage]))
                    
                    let result = try JSONDecoder().decode(ResponseModel<CampfireLogsPreviewResult>.self, from: response).result
                    
                    if !result.logOverviews.isEmpty {
                        // logs: [Log]를, monthlyLogs(MonthlyLogs Model과는 다름): [Date : [Log]] 형태로 (년, 월 기준으로)
                        let monthlyLogs = Dictionary(grouping: result.logOverviews) { log in
                            let components = Calendar.current.dateComponents([.year, .month], from: log.startAt.iso8601ToDate)
                            return Calendar.current.date(from: components)!
                        }
                        
                        // YearlyLogs를 최신 순으로 정렬하고, 각 월 안에서 다시 일별로 그룹화
                        currentCampfireYearlyLogs.monthlyLogs.append(contentsOf: monthlyLogs.sorted { $0.key > $1.key } // 최신 월 순으로 정렬
                            .map { (month, logsInMonth) in
                                // 같은 월 안에서 다시 일별로 그룹화
                                let dailyLogs = Dictionary(grouping: logsInMonth) { log in
                                    Calendar.current.startOfDay(for: log.startAt.iso8601ToDate) // 일 단위로 그룹화
                                }
                                
                                // 날짜별 로그들을 최신 날짜 순으로 정렬
                                let sortedDailyLogs = dailyLogs.sorted { $0.key > $1.key }
                                    .map { (day, logsInDay) in
                                        DailyLogsOverview(date: day, logs: logsInDay.sorted { $0.startAt.iso8601ToDate > $1.startAt.iso8601ToDate }) // 시간순으로 정렬
                                    }
                                
                                // 월 단위로 묶고, 그 안에 일별로 묶인 로그들 포함
                                return MonthlyLogsOverview(date: month, dailyLogs: sortedDailyLogs)
                            })
                        currentCampfireYearlyLogs.hasNext = result.hasNext
                        currentCampfireYearlyLogs.currentPage += 1
                    }
                } catch {
                    print("testFetchMoreCampfireLogsPreview error: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func getCampfireLogImages(logId: Int) async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .getCampfireLogImages(campfirePin: currentCampfirePin, logId: logId, parameters: [:]))
            
            let result = try JSONDecoder().decode(ResponseModel<CampfireLogImagesResult>.self, from: response).result
            
            currentCampfireLogImagesData = .init(logId: result.logId, images: result.images, hasNext: result.hasNext, currentPage: 0)
            currentCampfireLogImagesData.currentPage += 1
        } catch {
            print("getCampfireLogImages error: \(error)")
        }
    }
    
    @MainActor
    func getMoreCampfireLogImages(logId: Int) {
        if currentCampfireLogImagesData.hasNext {
            Task {
                do {
                    let response = try await NetworkManager.shared.requestRawData(router: .getCampfireLogImages(campfirePin: currentCampfirePin, logId: logId, parameters: ["page": currentCampfireLogImagesData.currentPage]))
                    
                    let result = try JSONDecoder().decode(ResponseModel<CampfireLogImagesResult>.self, from: response).result
                    
                    currentCampfireLogImagesData.images.append(contentsOf: result.images)
                    currentCampfireLogImagesData.hasNext = result.hasNext
                    currentCampfireLogImagesData.currentPage += 1
                } catch {
                    print("getMoreCampfireLogImages error: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func getCampfireLogImageDetail(imageId: Int) async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .getCampfireLogImageDetail(campfirePin: currentCampfirePin, imageId: imageId))
            
            let result = try JSONDecoder().decode(ResponseModel<CampfireLogImageDetailResult>.self, from: response).result
            
            currentCampfireLogImageDetail = result
        } catch {
            print("getCampfireLogImageDetail error: \(error)")
        }
    }
    
    func updateCampfireName(newName: String) async {
        do {
            let response = try await NetworkManager.shared.requestRawData(router: .updateCampfireName(campfirePin: currentCampfirePin, parameters: ["newCampfireName": newName]))
            print("updateCampfireName success: \(response)")
            
            Task {
                await testFetchCampfireInfos()
                await testFetchMainCampfireInfo()
            }
        } catch {
            print("updateCampfireName error: \(error)")
        }
    }
    
    func fetchCampfireMainInfo() {
        if recentVisitedCampfirePin != 0 {
            fetchCampfireMainInfo(for: recentVisitedCampfirePin)
        } else {
            fetchUserCampfireInfos { _ in }
        }
    }
    
    // 특정 캠프파이어 핀으로 메인 화면 정보를 가져옴
    private func fetchCampfireMainInfo(for campfirePin: Int) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getCampfireMainInfo(campfirePin: campfirePin))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any] {
                    
                    // Campfire 모델에 대한 JSON 응답 디코딩
                    let jsonData = try JSONSerialization.data(withJSONObject: result, options: [])
                    let campfire = try JSONDecoder().decode(Campfire.self, from: jsonData)
                    
                    DispatchQueue.main.async {
                        self.currentCampfire = campfire
                        self.isEmptyCampfire = false
                        self.recentVisitedCampfirePin = campfire.pin
                    }
                } else {
                    print("Failed to parse campfire info.")
                    DispatchQueue.main.async {
                        self.isEmptyCampfire = true
                    }
                }
            } catch {
                print("Error fetching campfire info: \(error)")
                DispatchQueue.main.async {
                    self.isEmptyCampfire = true
                }
            }
        }
    }
    
    // 사용자가 참여한 모든 캠프파이어 목록에서 첫 번째 캠프파이어 정보를 가져옴
    func fetchUserCampfireInfos(completion: @escaping ([Campfire]?) -> Void) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .getMyCampfires)
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any],
                   let campfireInfos = result["campfireInfos"] as? [[String: Any]],
                   let _ = campfireInfos.first {
                    
                    // Campfire 모델에 대한 JSON 응답 디코딩
                    let fetchedCampfires = try campfireInfos.map { campfireInfo -> Campfire in
                        let jsonData = try JSONSerialization.data(withJSONObject: campfireInfo, options: [])
                        return try JSONDecoder().decode(Campfire.self, from: jsonData)
                    }
                    
                    DispatchQueue.main.async {
                        self.myCampfires = fetchedCampfires
                        self.currentCampfire = fetchedCampfires.first(where: { $0.pin == self.recentVisitedCampfirePin }) ?? fetchedCampfires.first
                        self.isEmptyCampfire = fetchedCampfires.isEmpty
                        
                        // 콜백으로 데이터를 반환
                        completion(fetchedCampfires)
                    }
                } else {
                    print("User has no campfire.")
                    DispatchQueue.main.async {
                        self.isEmptyCampfire = true
                        completion(nil)
                    }
                }
            } catch {
                print("Error fetching user campfire infos: \(error)")
                DispatchQueue.main.async {
                    self.isEmptyCampfire = true
                    completion(nil)
                }
            }
        }
    }
    
    func createCampfire(campfireName: String, completion: @escaping () -> Void) {
        Task {
            do {
                let data = try await NetworkManager.shared.requestRawData(router: .createCampfire(campfireName: campfireName))
                
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let result = jsonResponse["result"] as? [String: Any],
                   let campfirePin = result["campfirePin"] as? Int {
                    
                    DispatchQueue.main.async {
                        self.recentVisitedCampfirePin = campfirePin
                        self.fetchCampfireMainInfo(for: campfirePin)
                        completion()
                    }
                    print("Successfully created campfire with PIN: \(campfirePin)")
                } else {
                    print("Failed to parse response for campfire creation.")
                }
            } catch {
                print("Error creating campfire: \(error)")
            }
        }
    }
    
    func showTemporaryNetworkAlert() {
        withAnimation {
            self.showNetworkAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showNetworkAlert = false
            }
        }
    }
    
    func showEmptyLogPileAlert() {
        withAnimation {
            self.showEmptyLogAlert = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showEmptyLogAlert = false
            }
        }
    }
    
    func updateRecentVisitedCampfirePin(to pin: Int) {
        recentVisitedCampfirePin = pin
        fetchCampfireMainInfo()  // 새로운 pin에 맞는 캠프파이어 정보 가져오기
    }
    
    func getWebpImageDataURL(imageURLName: String?) -> URL? {
        if let urlString = imageURLName, urlString != "" {
            do {
                let baseURL = Bundle.main.environmentVariable(forKey: "ImageURL")
                let totalURL = baseURL! + "/" + urlString
                if let url = URL(string: totalURL) {
                    return url
                } else {
                    throw NetworkError.invalidURL
                }
            } catch {
                print("getWebpImageDataURL Error: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    func getWebpImageData(imageURLName: String) async -> Data? {
        do {
            let baseURL = Bundle.main.environmentVariable(forKey: "ImageURL")
            let totalURL = baseURL! + "/" + imageURLName
            if let url = URL(string: totalURL) {
                let response = try await URLSession.shared.data(from: url)
                let imageData = response.0
                return imageData
            } else {
                throw NetworkError.invalidURL
            }
        } catch {
            print("getWebpImageData Error: \(error)")
            return nil
        }
    }
    
    private func convertWebpDataToUIImage(webpData: Data?) -> UIImage? {
        if let data = webpData {
            let uiImage = SDImageWebPCoder.shared.decodedImage(with: data)
            return uiImage
        } else {
            return nil
        }
    }
    
    func fetchTodayImageURL() async {
        do {
            if let todayImageName = self.mainCampfireInfo?.todayImage.name, todayImageName != "" {
                let baseURL = Bundle.main.environmentVariable(forKey: "ImageURL")
                let totalURL = baseURL! + "/" + todayImageName
                if let url = URL(string: totalURL) {
                    DispatchQueue.main.async {
                        self.mainTodayImageURL = url
                    }
                } else {
                    throw NetworkError.invalidURL
                }
            } else {
                throw NetworkError.invalidURL
            }
        } catch {
            print("fetchTodayImageURL Error: \(error)")
            DispatchQueue.main.async {
                self.mainTodayImageURL = nil
            }
        }
    }
    
    func updateTodayImageEmotion(emotion: String) async {
        if let campfire = mainCampfireInfo {
            do {
                let response = try await NetworkManager.shared.requestRawData(router: .updateTodayImageEmotion(campfirePin: campfire.campfirePin, imageId: campfire.todayImage.imageId, parameters: ["emotion" : emotion]))
                
                let result = try JSONDecoder().decode(ResponseModel<CampfireTodayImageEmotionResult>.self, from: response)
                
                print("updateTodayImageEmotion result:\n\(result)")
            } catch {
                print("updateTodayImageEmotion error:\n\(error)")
            }
        } else {
            print("updateTodayImageEmotion mainCampfireInfo nil error")
        }
    }
}



