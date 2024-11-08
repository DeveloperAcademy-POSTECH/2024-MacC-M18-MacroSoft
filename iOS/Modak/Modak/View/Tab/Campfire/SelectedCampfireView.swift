//
//  SelectedCampfireView.swift
//  Modak
//
//  Created by Park Junwoo on 11/1/24.
//

import SwiftUI

struct SelectedCampfireView: View {
    // TODO: 참여한 모닥불의 로그가 없는지 체크하는 로직 추가
    @State private var isEmptyCampfireLog: Bool = true
    // TODO: 참여한 모닥불의 이름 가져오는 로직 추가
    @State private var campfireName: String = "MacroSoft"
    @Binding private(set) var isShowSideMenu: Bool
    
    var body: some View {
        VStack {
            CampfireViewTopButton(isShowSideMenu: $isShowSideMenu, campfireName: $campfireName)
            
            // TODO: 참여한 모닥불의 로그가 없는지 체크하는 로직 추가
            if isEmptyCampfireLog {
                CampfireEmptyLog(campfireName: $campfireName)
                
                Spacer()
            } else {
                CampfireViewTodayPhoto()
                
                Spacer()
                
                ExpandableEmoji(emojiList: ["laugh", "embarrassed", "panic", "cry", "heart", "death"])
                    .padding(.trailing, 24)
                    .padding(.bottom)
            }
        }
    }
}

// MARK: - CampfireViewTopButton

private struct CampfireViewTopButton: View {
    @Binding private(set) var isShowSideMenu: Bool
    @Binding private(set) var campfireName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                withAnimation {
                    isShowSideMenu = true
                }
            } label: {
                HStack(spacing: 8) {
                    // TODO: 모닥불 이미지 적용하는 로직 추가
                    Image(.leaf)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Text(campfireName)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .foregroundStyle(.textColor1)
                        .font(Font.custom("Pretendard-Semibold", size: 18))
                }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 10))
            }
            .background {
                Rectangle().fill(Color.init(hex: "221F20")).clipShape(.rect(bottomTrailingRadius: 12, topTrailingRadius: 12))
            }
            
            Spacer(minLength: 16)
            
            NavigationLink {
                // TODO: 해당 모닥불의 장작 창고로 이동하는 로직 추가
            } label: {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.init(hex: "221F20"))
                    .stroke(Color.init(hex: "6E615F").opacity(0.32), lineWidth: 1)
                    .frame(width: 45, height: 45)
                    .overlay {
                        Image(.logs)
                            .resizable()
                            .padding(4)
                    }
            }
            .padding(.trailing)
            .padding(.top, 6)
        }
        .padding(.bottom)
    }
}

// MARK: - CampfireViewTodayPhoto

private struct CampfireViewTodayPhoto: View {
    @State private var randomRotation: Bool = Bool.random()
    @State private var isTodayPhotoFullSheet: Bool = false
    
    // TODO: 오늘의 사진 높이가 320 넘는지 판별하는 로직 추가하기
    private var isTodayPhotoHeightOver320: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            Button {
                isTodayPhotoFullSheet = true
            } label: {
                // TODO: 오늘의 이미지 넣는 로직 추가
                Image(.photosIcon)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 8))
            }
            
            Text("오늘의 사진")
                .font(Font.custom("Pretendard-medium", size: 16))
                .foregroundStyle(.textColorTitleView)
                .padding(.bottom, 8)
        }
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.init(hex: "221F20"))
                .stroke(Color.init(hex: "6E615F").opacity(0.32), lineWidth: 1)
        }
        .shadow(color: .black.opacity(0.25), radius: 9.09486, x: 0, y: 4.54743)
        // TODO: 오늘의 사진 높이가 320 넘는지 판별하는 로직 추가하기
        .frame(width: 320, height: isTodayPhotoHeightOver320 ? 320 : .infinity)
        .rotationEffect(.degrees(randomRotation ? 2 : -2))
        .fullScreenCover(isPresented: $isTodayPhotoFullSheet) {
            // TODO: 선택한 이미지가 보이도록 로직 추가
            ExpandedPhoto(photo: .progressDefault)
                .presentationBackground(Color.black.opacity(0.8))
        }
    }
}

#Preview {
    SelectedCampfireView(isShowSideMenu: .constant(false))
}
