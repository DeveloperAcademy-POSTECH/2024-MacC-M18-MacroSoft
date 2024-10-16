//
//  LogPileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import SwiftData
import Photos

struct LogPileView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var groupedByLogs: [(date: Date, logs: [Log])] = []
    
    var body: some View {
        Group {
            if groupedByLogs.count > 0 {
                ScrollView {
                    LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                        ForEach($groupedByLogs, id: \.date) { groupedByLog in
                            Section {
                                LogPileViewRow(groupedByLog: groupedByLog)
                                    .background(LinearGradient.logPileRowBackground)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .padding([.horizontal, .bottom], 10)
                                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                            } header: {
                                LogPileViewSubTitle(date: groupedByLog.date.wrappedValue)
                            }
                        }
                    }
                }
            } else {
                NoLogView()
            }
        }
        .background(.backgroundLogPile)
        .onAppear {
            fetchLogsWithGroupBy()
        }
    }
    
    // MARK: - fetchLogsWithGroupBy
    
    private func fetchLogsWithGroupBy() {
        do {
            let logs = try modelContext.fetch(FetchDescriptor<Log>())
            
            // logs: [Log]를, groupedByYM: [Date : [Log]] 형태로 그룹화
            let groupedByYM = Dictionary(grouping: logs) { log in
                let components = Calendar.current.dateComponents([.year, .month], from: log.startAt)
                return Calendar.current.date(from: components)!
            }
            
            // groupedByYM를 최신 순으로 정렬 및 같은 월이면 하나의 그룹으로 로그 묶기
            groupedByLogs = groupedByYM.sorted { $0.key > $1.key } // 최신 순으로 정렬
                .map { (month, logsInMonth) in
                    // 같은 월이면 하나의 그룹으로 로그 묶기
                    let mergedLogs = logsInMonth // 하나의 그룹으로 묶인 로그들 최신 순으로 정렬
                        .sorted { $0.startAt > $1.startAt }
                    return (date: month, logs: mergedLogs)
                }
        } catch {
            print("fetchLogsWithGroupBy failed: \(error)")
        }
    }
}

// MARK: - LogPileViewSubTitle

private struct LogPileViewSubTitle: View {
    private(set) var date: Date
    // TODO: calendar는 초기값을 넣어주는 형태라서 private만 줬는데 오류가 발생해서 private(set)으로 변경...왜...?
    private(set) var calendar: Calendar = .current
    
    var body: some View {
        // TODO: Text 표시하는 로직 수정
        // TODO: date가 혹시라도 nil이거나 dateComponents를 통해 나온 날짜 값이 nil인 경우 처리
        Group {
            if let year = calendar.dateComponents([.year], from: date).year, let month = calendar.dateComponents([.month], from: date).month{
                Text("\(year.description)년 ")
                    .foregroundStyle(.textColor4)
                +
                Text("\(month)월")
                    .foregroundStyle(.textColor2)
            } else {
                Text("년 ")
                    .foregroundStyle(.textColor4)
                +
                Text("월")
                    .foregroundStyle(.textColor2)
            }
            
        }
        .font(Font.custom("Pretendard-Medium", size: 21))
        .padding(.leading, 24)
    }
}

// MARK: - LogPileViewRowTitle

private struct LogPileViewRowTitle: View {
    private(set) var date: Date
    private(set) var location: String?
    private(set) var isLeaf: Bool
    
    init(date: Date, location: String? = nil, isLeaf: Bool) {
        self.date = date
        self.isLeaf = isLeaf
        if location == "위치 정보 없음" {
            self.location = "지구"
        }else {
            self.location = location
        }
    }
    
    var body: some View {
        // TODO: Text 표시하는 로직 수정
        HStack(spacing: 10) {
            Image(isLeaf ? .leaf : .log)
            VStack(alignment: .leading, spacing: 4) {
                Text(location ?? "지구")
                    .foregroundStyle(.textColor3)
                    .font(Font.custom("Pretendard-Bold", size: 16))
                +
                Text("에서 발견된 장작")
                    .foregroundStyle(.textColorGray1)
                    .font(Font.custom("Pretendard-Light", size: 15))
                
                Text("\(date.logPileRowTitleDayFormat) ")
                    .font(
                        Font.custom("Pretendard-Medium", size: 12)
                    )
                    .foregroundStyle(.textColorGray1.opacity(0.55))
                +
                Text(date.logPileRowTitleTimeFormat)
                    .font(
                        Font.custom("Pretendard-Medium", size: 12)
                    )
                    .foregroundStyle(.textColorGray4.opacity(0.54))
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.textColorGray1)
        }
    }
}

// MARK: - LogPileViewRowFrame

private struct LogPileViewRowFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.textColor2.opacity(0.2), lineWidth: 0.33)
    }
}

// MARK: - LogPileViewRowImage

private struct LogPileViewRowImage: View {
    let photoMetadata: PhotoMetadata
    @State private var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
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

// MARK: - LogPileViewRow

private struct LogPileViewRow: View {
    @Binding private(set) var groupedByLog: (date: Date, logs: [Log])
    
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 87), spacing: 1), count: 4)
    
    var body: some View {
        // TODO: 옵셔널 언래핑 실패 시 로직 구현
        if let groupedByLogFirst = groupedByLog.logs.first, let groupedByLogLast = groupedByLog.logs.last {
            VStack(spacing: 0) {
                ForEach(groupedByLog.logs, id: \.id) { log in
                    
                    NavigationLink {
                        LogPileDetailView(selectedLog: log)
                    } label: {
                        VStack(spacing: groupedByLogFirst.id == groupedByLogLast.id ? 14 : 12) {
                            if log.id == groupedByLogFirst.id || groupedByLogFirst.id == groupedByLogLast.id {
                                LogPileViewRowTitle(date: log.endAt, location: log.address, isLeaf: false)
                            } else {
                                LogPileViewRowTitle(date: log.endAt, location: log.address, isLeaf: true)
                            }
                            HStack(spacing: 14) {
                                if log.id != groupedByLogLast.id {
                                    Divider()
                                        .frame(width: 1)
                                        .background(.pagenationDisable)
                                        .padding(.init(top: -5, leading: 12, bottom: -7, trailing: 0))
                                }
                                LazyVGrid(columns: gridItems, spacing: 1) {
                                    ForEach(0..<((4...7).contains(log.images.count) ? 4 : 8), id: \.self) { index in
                                        Group {
                                            if (log.images.count == 3 && index == 2) || (log.images.count == 2 && index == 1) || (log.images.count == 1 && index == 0) {
                                                LogPileViewRowImage(photoMetadata: log.images[index])
                                                // clipShape 때문에 Group을 못 썼는데 이 로직으로 들어오는 경우가 없어서 일단 Group 사용함
                                                    .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                                            } else {
                                                LogPileViewRowImage(photoMetadata: log.images[index])
                                            }
                                        }
                                        .aspectRatio(1, contentMode: .fill)
                                        .foregroundStyle(.textColorTitleView)
                                    }
                                }
                                .background(.backgroundLogPile)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            }
                            .padding(.bottom, log.id == groupedByLogLast.id ? 0 : 20)
                        }
                    }
                }
            }
            .padding(.init(top: 16, leading: 10, bottom: 10, trailing: 10))
            .overlay {
                LogPileViewRowFrame()
            }
        }
        
    }
}

// MARK: - NoLogView

private struct NoLogView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("캠핑장이 너무 추워요")
                .font(
                    Font.custom("Pretendard-Bold", size: 22)
                )
                .foregroundColor(.textColorGray1)
                .padding(.bottom, 8)
            
            Text("따뜻하게 불을 지필 수 있도록 \n내 사진으로 장작을 만들어주세요")
                .font(Font.custom("Pretendard-Regular", size: 16))
                .multilineTextAlignment(.center)
                .foregroundColor(.textColorGray2)
                .padding(.bottom, 27)
            
            NavigationLink {
                AuthorizationView()
            } label: {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.mainColor1)
                    .overlay {
                        Text("내 사진에서 장작 구해오기")
                            .font(
                                Font.custom("Pretendard-Bold", size: 16)
                            )
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .padding(.horizontal, 24)
                    }
            }
            .frame(height: 51)
            Spacer()
        }
        .padding(.horizontal, 90)
    }
}

#Preview {
    LogPileView()
}
