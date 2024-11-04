//
//  ExpandableEmoji.swift
//  Modak
//
//  Created by Park Junwoo on 11/4/24.
//

import SwiftUI

struct ExpandableEmoji: View {
    @State private var isShowEmojiPicker: Bool = true
    // TODO: 오늘의 사진에 반응한 이모지로 연결
    @State private var currentEmoji: String = "death"
    
    private(set) var emojiList: [String]
    
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
    }
}
