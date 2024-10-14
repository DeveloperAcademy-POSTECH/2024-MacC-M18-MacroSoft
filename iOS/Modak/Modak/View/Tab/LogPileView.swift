//
//  LogPileView.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

struct LogPileView: View {
    private var logPile: LogPileTestModel = logPileViewTestData
    
    var body: some View {
        
            Group {
                if logPile.logList.count > 0 {
                    ScrollView {
                        LazyVStack(alignment: .leading, pinnedViews: [.sectionHeaders]) {
                            ForEach(logPile.logList, id: \.self){ log in
                                Section {
                                    LogPileViewRow(pictureCount: log.pictureList.count)
                                        .background(LinearGradient.logPileRowBackground)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .padding([.horizontal, .bottom], 10)
                                        .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 3)
                                } header: {
                                    LogPileViewSubTitle(date: log.date)
                                }
                            }
                        }
                    }
                } else {
                    NoLogView()
                }
            }
            .background(.backgroundLogPile)
    }
}

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

private struct LogPileViewRowTitle: View {
    private(set) var date: Date
    private(set) var isLeaf: Bool
    
    var body: some View {
        // TODO: 역지오 코딩 적용
        // TODO: Text 표시하는 로직 수정
        HStack {
            Image(isLeaf ? .leaf : .log)
            VStack(alignment: .leading, spacing: 4) {
                Text("포항시 남구 ")
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
        }
    }
}

private struct LogPileViewRowFrame: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(.textColor2.opacity(0.2), lineWidth: 0.33)
    }
}

private struct LogPileViewRow: View {
    private(set) var pictureCount: Int = 8
    private(set) var gridItems: [GridItem] = Array(repeating: GridItem(.flexible(minimum: 80, maximum: 87), spacing: 1), count: 4)
    private(set)var isShowLeaf: Bool = true
    
    var body: some View {
        Group {
            if isShowLeaf{
                VStack(spacing: 0) {
                    NavigationLink {
                        LogPileDetailView()
                    } label: {
                        VStack {
                            LogPileViewRowTitle(date: Date(), isLeaf: false)
                            
                            HStack {
                                Divider()
                                    .frame(width: 1)
                                    .background(.pagenationDisable)
                                    .padding(.top, 6)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 14)
                                    .padding(.bottom, 14)
                                LazyVGrid(columns: gridItems, spacing: 1) {
                                    ForEach(0..<(pictureCount <= 3 ? pictureCount : pictureCount <= 7 ? 4 : 8), id: \.self) { count in
                                        if (pictureCount == 3 && count == 2) || (pictureCount == 2 && count == 1) || (pictureCount == 1 && count == 0) {
                                            Rectangle()
                                                .aspectRatio(1, contentMode: .fit)
                                                .foregroundStyle(.textColorTitleView)
                                                .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                                        } else {
                                            Rectangle()
                                                .aspectRatio(1, contentMode: .fit)
                                                .foregroundStyle(.textColorTitleView)
                                        }
                                    }
                                }
                                .background(.backgroundLogPile)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.top, 12)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    
                    NavigationLink {
                        LogPileDetailView()
                    } label: {
                        VStack {
                            LogPileViewRowTitle(date: Date(), isLeaf: true)
                            HStack {
                                Divider()
                                    .frame(width: 1)
                                    .background(.pagenationDisable)
                                    .padding(.top, 6)
                                    .padding(.leading, 12)
                                    .padding(.trailing, 14)
                                    .padding(.bottom, 14)
                                LazyVGrid(columns: gridItems, spacing: 1) {
                                    ForEach(0..<(pictureCount <= 3 ? pictureCount : pictureCount <= 7 ? 4 : 8), id: \.self) { count in
                                        if (pictureCount == 3 && count == 2) || (pictureCount == 2 && count == 1) || (pictureCount == 1 && count == 0) {
                                            Rectangle()
                                                .aspectRatio(1, contentMode: .fit)
                                                .foregroundStyle(.textColorTitleView)
                                                .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                                        } else {
                                            Rectangle()
                                                .aspectRatio(1, contentMode: .fit)
                                                .foregroundStyle(.textColorTitleView)
                                        }
                                    }
                                }
                                .background(.backgroundLogPile)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .padding(.top, 12)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }
            } else {
                NavigationLink {
                    LogPileDetailView()
                } label: {
                    VStack {
                        LogPileViewRowTitle(date: Date(), isLeaf: false)
                        
                        LazyVGrid(columns: gridItems, spacing: 1) {
                            ForEach(0..<(pictureCount <= 3 ? pictureCount : pictureCount <= 7 ? 4 : 8), id: \.self) { count in
                                if (pictureCount == 3 && count == 2) || (pictureCount == 2 && count == 1) || (pictureCount == 1 && count == 0) {
                                    Rectangle()
                                        .aspectRatio(1, contentMode: .fit)
                                        .foregroundStyle(.textColorTitleView)
                                        .clipShape(.rect(bottomTrailingRadius: 20, topTrailingRadius: 20))
                                } else {
                                    Rectangle()
                                        .aspectRatio(1, contentMode: .fit)
                                        .foregroundStyle(.textColorTitleView)
                                }
                            }
                        }
                        .background(.backgroundLogPile)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal, 10)
                        .padding(.top, 14)
                    }
                }
            }
        }
        .padding(.top, 16)
        .padding([.bottom,.horizontal], 10)
        .overlay {
            LogPileViewRowFrame()
        }
    }
}

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
