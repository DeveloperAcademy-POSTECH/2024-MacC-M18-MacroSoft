//
//  getDataExample.swift
//  Modak
//
//  Created by kimjihee on 10/14/24.
//

import SwiftUI
import Photos
import SwiftData

struct ExampleLogPileView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var logs: [Log] = []
    @State private var groupedLogs: [(date: Date, logs: [Log])] = []

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(groupedLogs, id: \.date) { group in
                        let logsForDate = group.logs.sorted { $0.startAt > $1.startAt }

                        ForEach(logsForDate, id: \.id) { log in
                            let logIndex = logsForDate.firstIndex(of: log) ?? 0
                            VStack(alignment: .leading, spacing: 8) {
                                // 첫 번째 로그만 "main", 나머지는 "sub"로 구분
                                Text(logIndex == 0 ? "Log main" : "Log sub \(logIndex)")
                                    .font(logIndex == 0 ? .headline : .subheadline)
                                    .padding(.leading, 16)

                                // 저장된 위치 정보 표시 (주소)
                                Text(log.address ?? "주소 없음")
                                    .font(.caption)
                                    .padding(.leading, 16)

                                // 평균 시간 정보 표시
                                if let averageDate = calculateAverageDate(log: log) {
                                    Text("평균 시간: \(formatDate(averageDate))")
                                        .font(.caption)
                                        .padding(.leading, 16)
                                }

                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 16) {
                                    ForEach(log.images, id: \.self) { imageMetadata in
                                        LogImageView(photoMetadata: imageMetadata)
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                                .padding(.leading, 16)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("클러스터 뷰")
        }
        .onAppear {
            fetchLogs() // 뷰가 나타날 때 로그 데이터를 불러옴
        }
    }

    private func fetchLogs() {
        do {
            logs = try modelContext.fetch(FetchDescriptor<Log>())
            print("불러온 로그 개수: \(logs.count)")

            let grouped = Dictionary(grouping: logs) { log in
                Calendar.current.startOfDay(for: log.startAt)
            }

            // 날짜 역순으로 정렬 (가장 최근 날짜가 위로 오게)
            groupedLogs = grouped.sorted { $0.key > $1.key }
                .map { ($0.key, $0.value) }
            
            for log in logs {
                print("로그 시작일: \(log.startAt), 이미지 개수: \(log.images.count), 주소: \(log.address ?? "없음")")
            }
        } catch {
            print("로그 불러오기 실패: \(error)")
        }
    }
    
    // 첫 사진과 마지막 사진의 시간의 평균값 계산 함수
    private func calculateAverageDate(log: Log) -> Date? {
        guard let firstImage = log.images.first?.creationDate,
                let lastImage = log.images.last?.creationDate else {
            return nil
        }

        let timeInterval = (firstImage.timeIntervalSince1970 + lastImage.timeIntervalSince1970) / 2
        return Date(timeIntervalSince1970: timeInterval)
    }

    // 날짜를 포맷팅하는 함수
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 오후 hh:mm"
        return formatter.string(from: date)
    }
}

// 사진을 표시하는 이미지 뷰
struct LogImageView: View {
    let photoMetadata: PhotoMetadata
    @State private var image: UIImage?

    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        } else {
            Color.gray
                .onAppear {
                    fetchImage(for: photoMetadata)
                }
        }
    }

    private func fetchImage(for metadata: PhotoMetadata) {
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [metadata.localIdentifier], options: nil)

        guard let asset = fetchResult.firstObject else {
            return
        }

        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat

        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

#Preview {
    ExampleLogPileView()
}

