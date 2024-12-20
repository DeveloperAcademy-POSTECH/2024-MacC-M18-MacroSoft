//
//  OrganizePhotoView.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI
import Photos
import SwiftData
import Firebase

struct OrganizePhotoView: View {
    @EnvironmentObject private var logPileViewModel: LogPileViewModel
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = OrganizePhotoViewModel()
    @State private var currentPage = 0
    @State private var showBottomSheet = false
    @State private var locationCache: [String: (center: CLLocationCoordinate2D, radius: Double, address: String)] = [:]
    @State private var isHidePhoto: Bool = false
    @State private var showAlert = false
    let geocoder = CLGeocoder()
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .pagenationAble
        UIPageControl.appearance().pageIndicatorTintColor = .pagenationDisable
    }
    
    var body: some View {
        ZStack {
            Color.backgroundDefault.ignoresSafeArea(.all)
            VStack {
                Image(viewModel.currentCount >= viewModel.totalCount ? "pagenationBar3" : "pagenationBar2")
                    .padding(.top, 24)
                
                TabView(selection: $currentPage) {
                    progressSection.tag(0)
                    onboardingCard(
                        title: "소중한 순간,\n자동으로 모아드릴게요",
                        titleHighlightRanges: [0...7],
                        context: "여행, 소풍, 즐거운 순간들.\n추억을 하나의 이야기로 모아드려요",
                        image: "onboarding_image1",
                        imagePadding: 10
                    ).tag(1)
                    onboardingCard(
                        title: "추억의 순간 속 사람들과\n모닥불에서 모이세요",
                        titleHighlightRanges: [14...16],
                        context: "함께한 사람들과 그룹을 만들고 추억을 모아보세요\n잊혀진 순간도 모닥불이 찾아드릴게요",
                        image: "onboarding_image2",
                        imagePadding: 10
                    ).tag(2)
                    onboardingCard(
                        title: "같이 만든 추억을\n함께 나누세요",
                        titleHighlightRanges: [9...16],
                        context: "추억으로 피워낸 모닥불 앞에 모여 함께 감상하세요\n",
                        image: "onboarding_image3",
                        imagePadding: 10
                    ).tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    Task {
                        await saveClusteredLogs()
                        logPileViewModel.fetchLogsWithGroupBy(modelContext: modelContext)
                    }
                    dismiss()
                }) {
                    RoundedRectangle(cornerRadius: 73)
                        .frame(width: 345, height: 58)
                        .foregroundStyle(viewModel.displayedCount >= viewModel.totalCount ? Color.mainColor1 : Color.disable)
                        .overlay {
                            Text("확인하러 가기")
                                .font(.custom("Pretendard-Bold", size: 17))
                                .lineSpacing(14 * 0.4)
                                .foregroundStyle(viewModel.displayedCount >= viewModel.totalCount ? Color.white : Color.textColorGray4)
                        }
                }
                .disabled(viewModel.displayedCount < viewModel.totalCount)
                .padding(.bottom, 14)
                
                Button(action: {
                    showBottomSheet.toggle()
                }) {
                    Text("장작이 무엇인가요?")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.mainColor1)
                        .underline()
                }
                
                Spacer(minLength: 12)
            }
            .multilineTextAlignment(.center)
            
            if showBottomSheet {
                BottomSheet(
                    isPresented: $showBottomSheet,
                    viewName: "OrganizePhotoView",
                    campfireName: .constant(nil),
                    createdAt: .constant(nil),
                    membersNames: .constant(nil)
                )
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            viewModel.startStatusMessageRotation()  // 메시지 회전 시작

            viewModel.applyDBSCAN {
                if viewModel.clusters.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showAlert = false
                        showAlert = true
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("추천할 장작이 없어요."),
                message: Text("선택한 사진으로 직접 장작을 만들 수 있어요. 다시 장작을 만드시겠어요?"),
                primaryButton: .default(Text("확인")) {
                    showAlert = false
                    viewModel.clusters.removeAll()
                    viewModel.photoMetadataList.removeAll()
                    viewModel.fetchPhotos(fromLast: 6, unit: .month, excludeScreenshots: false)
                    viewModel.applyDBSCAN(eps: 7200, minPts: 1) { }
                },
                secondaryButton: .cancel(Text("취소")) {
                    showAlert = false
                    dismiss()
                }
            )
        }
        .onAppear{
            Analytics.logEvent(AnalyticsEventScreenView,
                parameters: [AnalyticsParameterScreenName: "OrganizePhotoView",
                AnalyticsParameterScreenClass: "OrganizePhotoView"])
        }
        
    }
    
    private var progressSection: some View {
        VStack {
            Group {
                if viewModel.displayedCount >= viewModel.totalCount {
                    Text("장작을 모두 모았어요")
                        .foregroundStyle(Color.textColor3)
                } else {
                    Text(viewModel.statusMessage)
                        .foregroundStyle(Color.textColor3)
                }
            }
            .font(.custom("Pretendard-Bold", size: 23))
            .padding(.top, 14)
            
            Spacer()
            
            ProgressNumber(currentCount: viewModel.displayedCount, totalCount: viewModel.totalCount)
                .padding(.bottom, 26)
                            
            ZStack {
                CircularProgressBar(progress: Double(viewModel.displayedCount) / Double(viewModel.totalCount))
                Button {
                    isHidePhoto.toggle()
                } label: {
                    CircularProgressPhoto(image: viewModel.currentCircularProgressPhoto)
                        .overlay {
                            if isHidePhoto {
                                MaterialEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                                    .clipShape(.circle)
                            }
                        }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.bottom, 30)
                
            Spacer()
        }
        .onAppear {
            viewModel.updateDisplayedCount()
        }
    }
    
    private func saveClusteredLogs() async {
        var savedClusterIdentifiers = Set<String>()
        
        for cluster in viewModel.clusters {
            guard let firstMetadata = cluster.first, let lastMetadata = cluster.last else {
                print("클러스터에 이미지가 없습니다.")
                continue
            }

            let clusterID = firstMetadata.localIdentifier
            if savedClusterIdentifiers.contains(clusterID) {
                print("중복 클러스터 발견, 저장하지 않음: \(clusterID)")
                continue
            }

            savedClusterIdentifiers.insert(clusterID)

            let startAt = firstMetadata.creationDate ?? Date()
            let endAt = lastMetadata.creationDate ?? Date()

            let minLatitude = cluster.compactMap { $0.latitude }.min() ?? 0
            let maxLatitude = cluster.compactMap { $0.latitude }.max() ?? 0
            let minLongitude = cluster.compactMap { $0.longitude }.min() ?? 0
            let maxLongitude = cluster.compactMap { $0.longitude }.max() ?? 0
            var address = "위치 정보 없음"

            // 클러스터 내에서 위치 정보가 있는 첫 번째 사진을 찾음
            if let locationMetadata = cluster.first(where: { $0.latitude != nil && $0.longitude != nil }),
                let latitude = locationMetadata.latitude, let longitude = locationMetadata.longitude {

                let location = CLLocation(latitude: latitude, longitude: longitude)

                // 캐시된 범위 내에 있는지 확인
                if let cachedLocation = isWithinCachedRange(location) {
                    address = cachedLocation
                } else {
                    // 비동기로 주소 가져옴
                    do {
                        let placemarks = try await geocoder.reverseGeocodeLocation(location)
                        if let placemark = placemarks.first {
                            let city = placemark.locality ?? "알 수 없음"
                            address = "\(city)"

                            // 위치 정보 캐시에 저장 (포항시 범위 예시)
                            locationCache["\(city)"] = (
                                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                radius: 7000,  // 7km 반경
                                address: address
                            )
                        }
                    } catch {
                        print("Geocoding error")
                    }
                }
            }

            let newLog = PrivateLog(
                minLatitude: minLatitude,
                maxLatitude: maxLatitude,
                minLongitude: minLongitude,
                maxLongitude: maxLongitude,
                startAt: endAt,
                endAt: startAt,
                images: cluster,
                address: address // 위치 정보 포함하여 저장
            )

            modelContext.insert(newLog)

            do {
                try modelContext.save()
                print("로그와 주소 저장 성공: \(address)")
            } catch {
                print("로그와 주소 저장 실패: \(error)")
            }
        }
    }

    // 캐시된 위치 범위 내에 있는지 확인
    private func isWithinCachedRange(_ location: CLLocation) -> String? {
        for (_, value) in locationCache {
            let cachedCenter = CLLocation(latitude: value.center.latitude, longitude: value.center.longitude)
            let distance = location.distance(from: cachedCenter)

            // 캐시된 반경 내에 있으면 해당 주소 반환
            if distance <= value.radius {
                return value.address
            }
        }
        return nil
    }

}

#Preview {
    OrganizePhotoView()
}
