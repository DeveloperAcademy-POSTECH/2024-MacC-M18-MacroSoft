//
//  SelectMergeLogsView.swift
//  Modak
//
//  Created by Park Junwoo on 11/9/24.
//

import SwiftUI
import SwiftData
import FirebaseAnalytics

struct SelectMergeLogsView: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    @EnvironmentObject private var selectMergeLogsViewModel: SelectMergeLogsViewModel
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                SelectMergeLogsViewTitle()
                    .padding(.leading, 20)
                
                ScrollView {
                    LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                        ForEach($selectMergeLogsViewModel.mergeableLogPiles, id: \.id) { mergeableLogPile in
                            Section {
                                SelectMergeLogsViewLowSection(mergeableLogPile: mergeableLogPile.mergeableLogs)
                            } header: {
                                SelectMergeLogsViewLowHeader(isRecommendedLog: mergeableLogPile.isRecommendedLogPile.wrappedValue)
                            }
                        }
                    }
                    .padding(.bottom, 150)
                }
            }
            
            VStack {
                Spacer()
                
                SelectMergeLogsButton(hasSelectedMergeableLogs: selectMergeLogsViewModel.mergeableLogPiles.hasSelectedMergeableLogInLogPiles())
                    .background {
                        MaterialEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
                            .opacity(0.98)
                            .blur(radius: 16)
                            .padding(.bottom, -26)
                    }
            }
            if selectMergeLogsViewModel.isUploadCampfireLogsLoading {
                Color.black.opacity(0.4)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.white)
                    .scaleEffect(1.5)
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButton()
            }
        }
        .background(
            LinearGradient.SelectMergeLogsViewBackground
                .ignoresSafeArea()
        )
        .onAppear {
            Task {
                await selectMergeLogsViewModel.getCampfireLogsMetadata(campfirePin: campfireViewModel.mainCampfireInfo!.campfirePin)
                selectMergeLogsViewModel.fetchMergeableLogPiles(modelContext: modelContext)
            }
        }
        .onDisappear {
            selectMergeLogsViewModel.resetProperties()
        }
    }
}

// MARK: - SelectMergeLogsViewTitle

private struct SelectMergeLogsViewTitle: View {
    private let title: String = "모닥불에 넣을 장작을 골라주세요"
    
    var body: some View {
        Text(title)
            .foregroundStyle(.textColor1)
            .font(.custom("Pretendard-Bold", size: 22))
    }
}

// MARK: - SelectMergeLogsViewLowSection

private struct SelectMergeLogsViewLowSection: View {
    @Binding private(set) var mergeableLogPile: [MergeableLog]
    
    // TODO: Button 컴포넌트화 하기
    var body: some View {
        ForEach($mergeableLogPile, id: \.id) { mergeableLog in
            Group {
                if mergeableLog.isSelectedLog.wrappedValue {
                    Button {
                        mergeableLog.isSelectedLog.wrappedValue = false
                    } label: {
                        VStack(spacing: 8) {
                            SelectMergeLogsViewLowSectionTitle(mergeableLog: mergeableLog)
                            
                            SelectMergeLogsViewLowSectionContent(mergeableLog: mergeableLog)
                        }
                        .padding(.init(top: 16, leading: 10, bottom: 10, trailing: 10))
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.init(hex: "986A5A").opacity(0.2))
                                .stroke(.mainColor1, lineWidth: 1)
                        }
                    }
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 0)
                } else {
                    Button {
                        mergeableLog.isSelectedLog.wrappedValue = true
                    } label: {
                        VStack(spacing: 8) {
                            SelectMergeLogsViewLowSectionTitle(mergeableLog: mergeableLog)
                            
                            SelectMergeLogsViewLowSectionContent(mergeableLog: mergeableLog)
                        }
                        .padding(.init(top: 16, leading: 10, bottom: 10, trailing: 10))
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(LinearGradient.selectMergeLogsViewHeaderBackground.opacity(0.3))
                        }
                    }
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 0)
                }
            }
            .frame(height: 126)
            .padding(.horizontal)
        }
    }
}

// MARK: - SelectMergeLogsViewLowSectionTitle

private struct SelectMergeLogsViewLowSectionTitle: View {
    @Binding private(set) var mergeableLog: MergeableLog
    
    var body: some View {
        HStack(spacing: 10) {
            Image(.leaf3D)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(mergeableLog.address.checkAddressNilAndEmpty())")
                    .foregroundStyle(mergeableLog.isSelectedLog ? .textColor3 : .textColorGray2)
                    .font(.custom("Pretendard-Bold", size: 16))
                +
                Text(" 에서 발견한 장작")
                    .foregroundStyle(mergeableLog.isSelectedLog ? .textColor1 : .textColorGray2)
                    .font(.custom("Pretendard-Light", size: 15))
                
                Text(mergeableLog.startAt.logPileRowTitleDayFormat)
                    .foregroundStyle(.textColorGray2)
                    .font(.custom("Pretendard-Medium", size: 12))
                +
                Text(" ")
                    .font(.custom("Pretendard-Medium", size: 12))
                +
                Text(mergeableLog.startAt.logPileRowTitleTimeFormat)
                    .foregroundStyle(.disable)
                    .font(.custom("Pretendard-Medium", size: 12))
            }
            Spacer()
        }
    }
}

// MARK: - SelectMergeLogsViewLowSectionContent

private struct SelectMergeLogsViewLowSectionContent: View {
    @Binding private(set) var mergeableLog: MergeableLog
    
    var body: some View {
        LazyHGrid(rows: [GridItem(.fixed(53))], spacing: 1) {
            ForEach(mergeableLog.images.prefix(8), id: \.localIdentifier) { image in
                // TODO: 실제 개인 장작 Log 보여주기
                DrawPhoto(photoMetadata: image)
                    .frame(width: (UIScreen.main.bounds.width - 54) / CGFloat(mergeableLog.images.count > 8 ? 8 : mergeableLog.images.count))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - SelectMergeLogsViewLowHeader

private struct SelectMergeLogsViewLowHeader: View {
    private(set) var isRecommendedLog: Bool
    
    var body: some View {
        HStack {
            Text(isRecommendedLog ? "추천 장작" : "그 외의 장작")
            Spacer()
        }
        .foregroundStyle(.textColor4)
        .font(.custom("Pretendard-Bold", size: 16))
        .padding(.leading, 20)
    }
}

// MARK: - SelectMergeLogsButton

private struct SelectMergeLogsButton: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    @EnvironmentObject private var selectMergeLogsViewModel: SelectMergeLogsViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    private(set) var hasSelectedMergeableLogs: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                if hasSelectedMergeableLogs {
                    Button {
                        Task {
                            selectMergeLogsViewModel.isUploadCampfireLogsLoading = true
                            await selectMergeLogsViewModel.updateCampfireLogs(campfirePin: campfireViewModel.mainCampfireInfo!.campfirePin)
                            await campfireViewModel.testFetchCampfireInfos()
                            await campfireViewModel.testFetchMainCampfireInfo()
                            await campfireViewModel.testFetchCampfireLogsPreview()
                            if let todayImage = campfireViewModel.mainCampfireInfo?.todayImage {
                                campfireViewModel.mainTodayImage = await campfireViewModel.fetchTodayImage(imageURLName: todayImage.name)
                            }
                            dismiss()
                        }
                        Analytics.logEvent("merge_log_pushed", parameters: ["mergedLogCount": selectMergeLogsViewModel.mergeableLogPiles.countSelectedMergeableLogInLogPiles()])
                    } label: {
                        
                        Text("장작 던져넣기")
                            .foregroundStyle(.white)
                            .font(.custom("Pretendard-Bold", size: 17))
                            .padding(.init(top: 18, leading: 126, bottom: 18, trailing: 126))
                            .background {
                                RoundedRectangle(cornerRadius: 73)
                                    .fill()
                            }
                    }
                    .padding(.top, 36)
                } else {
                    Text("최소 1개 이상을 넣어야 불을 붙일 수 있어요")
                        .foregroundStyle(.white)
                        .font(.custom("Pretendard-regular", size: 15))
                        .padding(.bottom, 12)
                    
                    Text("장작 던져넣기")
                        .foregroundStyle(.textColorGray4)
                        .font(.custom("Pretendard-Bold", size: 17))
                        .padding(.init(top: 18, leading: 126, bottom: 18, trailing: 126))
                        .background {
                            RoundedRectangle(cornerRadius: 73)
                                .fill(.disable)
                        }
                }
            }
            .padding(.bottom, 45)
            
            Spacer()
        }
    }
}

#Preview {
    SelectMergeLogsView()
}
