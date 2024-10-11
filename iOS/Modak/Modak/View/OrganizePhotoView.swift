//
//  OrganizePhotoView.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI
import Photos

struct OrganizePhotoView: View {
    @StateObject private var viewModel = OrganizePhotoViewModel()
    @State private var currentPage = 0
    @State private var showBottomSheet = false
    
    init() {
        // 페이지 인디케이터 색상 설정
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
                    progressSection
                        .tag(0)
                    onboardingCard(
                        title: "소중한 순간,\n자동으로 모아드릴게요",
                        titleHighlightRanges: [0...7],
                        context: "여행, 소풍, 즐거운 순간들,\n시공간에 따른 추억을 하나의 이야기로 모아드려요",
                        image: "추억(장작)을 정리하기\n패기"
                    ).tag(1)
                    onboardingCard(
                        title: "추억의 순간 속 사람들과\n모닥불에서 모이세요",
                        titleHighlightRanges: [14...16],
                        context: "함께한 사람들과 그룹을 만들고 추억을 모아보세요\n잊혀진 순간이 있더라도 모닥불이 찾아드릴게요",
                        image: "추억을 장작 삼아서 불지피기"
                    ).tag(2)
                    onboardingCard(
                        title: "같이 만든 추억을\n함께 나누세요",
                        titleHighlightRanges: [9...16],
                        context: "추억으로 피워낸 모닥불 앞에 모여 함께 감상하세요\n",
                        image: "다같이 캠프파이어 즐기는 모습"
                    ).tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                Spacer(minLength: 0)
                
                Button(action: {
                    // 동작 추가 필요
                }) {
                    RoundedRectangle(cornerRadius: 73)
                        .frame(width: 345, height: 58)
                        .foregroundStyle(viewModel.currentCount >= viewModel.totalCount ? Color.mainColor1 : Color.disable)
                        .overlay {
                            Text("확인하러 가기")
                                .font(.custom("Pretendard-Bold", size: 17))
                                .lineSpacing(14 * 0.4)
                                .foregroundStyle(viewModel.currentCount >= viewModel.totalCount ? Color.white : Color.textColorGray4)
                        }
                }
                .disabled(viewModel.currentCount >= viewModel.totalCount)
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
                BottomSheet(isPresented: $showBottomSheet, viewName: "OrganizePhotoView")
                    .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            viewModel.applyDBSCAN()
            viewModel.startStatusMessageRotation()
        }
    }
    
    private var progressSection: some View {
        VStack {
            Group {
                if viewModel.currentCount >= viewModel.totalCount {
                    Text("장작을 모두 모았어요")
                        .foregroundStyle(Color.textColor3)
                } else {
                    Text(viewModel.statusMessage)
                        .foregroundStyle(Color.textColor3)
                }
            }
            .font(.custom("Pretendard-Bold", size: 23))
            .padding(.top, 14)
            .padding(.bottom, 65)
            
            ProgressNumber(currentCount: viewModel.currentCount, totalCount: viewModel.totalCount)
                            .padding(.bottom, 26)
                        
            ZStack {
                CircularProgressBar(progress: Double(viewModel.currentCount) / Double(viewModel.totalCount))
                CircularProgressPhoto(image: viewModel.currentCircularProgressPhoto)
            }
            
            Spacer()
        }
    }
}

#Preview {
    OrganizePhotoView()
}
