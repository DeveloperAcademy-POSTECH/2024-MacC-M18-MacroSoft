//
//  ExpandableEmoji.swift
//  Modak
//
//  Created by Park Junwoo on 11/4/24.
//

import SwiftUI
import FirebaseAnalytics

struct ExpandableEmoji: View {
    @EnvironmentObject private var campfireViewModel: CampfireViewModel
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    @State private var isShowEmojiPicker: Bool = true
    
    private(set) var emojiList: [String]
    
    var body: some View {
        HStack {
            Spacer()
            if let currentCampfire = campfireViewModel.mainCampfireInfo, let myEmotion = currentCampfire.todayImage.emotions.first(where: {$0.memberNickname == profileViewModel.originalNickname }), !isShowEmojiPicker {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isShowEmojiPicker = true
                    }
                } label: {
                    Image(myEmotion.emotion)
                        .resizable()
                        .frame(width: 30, height: 30)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.disable, lineWidth: 1)
                )
            } else {
                HStack(spacing: 16) {
                    ForEach(emojiList, id: \.self) { emoji in
                        Button {
                            Task {
                                await campfireViewModel.updateTodayImageEmotion(emotion: emoji)
                                await campfireViewModel.testFetchMainCampfireInfo()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isShowEmojiPicker = false
                                }
                            }
                            Analytics.logEvent("reaction_tapped", parameters: ["reactionName": emoji])
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
            }
        }
        .onAppear {
            if let currentCampfire = campfireViewModel.mainCampfireInfo, currentCampfire.todayImage.emotions.first(where: {$0.memberNickname == profileViewModel.originalNickname }) != nil {
                isShowEmojiPicker = false
            } else {
                isShowEmojiPicker = true
            }
        }
        .onChange(of: campfireViewModel.mainCampfireInfo) {
            if let currentCampfire = campfireViewModel.mainCampfireInfo, currentCampfire.todayImage.emotions.first(where: {$0.memberNickname == profileViewModel.originalNickname }) != nil {
                isShowEmojiPicker = false
            } else {
                isShowEmojiPicker = true
            }
        }
    }
}
