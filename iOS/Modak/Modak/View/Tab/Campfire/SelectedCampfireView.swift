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
    
    var body: some View {
        CampfireViewTopButton(campfireName: $campfireName)
        // TODO: 참여한 모닥불의 로그가 없는지 체크하는 로직 추가
        if isEmptyCampfireLog {
            CampfireViewEmptyLogView(campfireName: $campfireName)
            
            Spacer()
        } else {
            CampfireViewTodayPhoto()
            
            Spacer()
            
            CampfireViewEmoji()
        }
    }
}

// MARK: - CampfireViewTopButton

private struct CampfireViewTopButton: View {
    @State private var isShowSideMenu: Bool = false
    
    @Binding private(set) var campfireName: String
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                // TODO: Side Menu 열기 로직 추가
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
            TodayPhotoFullSheet()
        }
    }
}

// MARK: - TodayPhotoFullSheet

private struct TodayPhotoFullSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 21, height: 21)
                        .foregroundStyle(.textColorGray1)
                }
                .padding(.trailing, 20)
            }
            Spacer()
            Image(.photosIcon)
                .resizable()
                .scaledToFit()
            Spacer()
        }
        .presentationBackground(Color.black.opacity(0.8))
    }
}

// MARK: - CampfireViewEmoji

private struct CampfireViewEmoji: View {
    @State private var isShowEmojiPicker: Bool = true
    @State private var currentEmoji: String = "death"
    
    private var emojiList: [String] = ["laugh", "embarrassed", "panic", "cry", "heart", "death"]
    
    var body: some View {
        HStack {
            Spacer()
            if isShowEmojiPicker {
                HStack(spacing: 16) {
                    ForEach(emojiList, id: \.self) { emoji in
                        Button {
                            currentEmoji = emoji
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isShowEmojiPicker = false
                            }
                        } label: {
                            Image(emoji)
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color(hex: "221F20"))
                }
                .animation(.easeInOut(duration: 0.3), value: isShowEmojiPicker)
            } else {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowEmojiPicker = true
                    }
                } label: {
                    Image(currentEmoji)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.disable, lineWidth: 1)
                )
            }
        }
        .padding(.trailing, 24)
        .padding(.bottom)
    }
}

// MARK: - CampfireViewEmptyLogView

private struct CampfireViewEmptyLogView: View {
    @Binding private(set) var campfireName: String
    
    var body: some View {
        VStack {
            Spacer()
            Text("추억 장작이 필요해요")
                .foregroundStyle(.textColorGray1)
                .font(Font.custom("Pretendard-Bold", size: 20))
                .padding(.bottom, 8)
            
            Text("\(campfireName) 모닥불에 추억 장작을 넣어\n오늘의 사진을 확인해보세요")
                .foregroundStyle(.textColorGray2)
                .font(Font.custom("Pretendard-Regular", size: 16))
                .padding(.bottom, 22)
                .lineSpacing(16 * 0.5)
                .multilineTextAlignment(.center)
            
            // TODO: 내 추억 장작 개수가 1개 미만인 경우 disable 시키는 로직 추가
            NavigationLink {
                // TODO: 화면 전환 로직 추가
            } label: {
                HStack(spacing: 8) {
                    Spacer()
                    Image(.log3D)
                        .overlay {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(Color.init(hex: "F1DCD1"))
                                }
                            }
                        }
                    Text("모닥불에 장작 넣기")
                        .foregroundStyle(.white)
                        .font(Font.custom("Pretendard-Bold", size: 16))
                    Spacer()
                }
                .padding(.vertical, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.init(hex: "4C4545"))
                    .stroke(Color.disable, lineWidth: 1)
            }
            .padding(.horizontal, 70)
            
            Spacer()
        }
    }
}


#Preview {
    SelectedCampfireView()
}
