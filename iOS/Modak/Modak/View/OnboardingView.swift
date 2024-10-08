//
//  OnboardingView.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI

public func onboardingView(title: String, titleHighlightRanges: [ClosedRange<Int>], context: String, image: String) -> some View {
    var highlightedText = Text("")
    
    for (index, character) in title.enumerated() {
        let currentCharacter = String(character)
        // titleHighlightRanges 배열에 있는 모든 범위를 검사
        let isHighlighted = titleHighlightRanges.contains { $0.contains(index) }
        
        if isHighlighted {
            highlightedText = highlightedText + Text(currentCharacter).foregroundStyle(Color.textColor2)
        } else {
            highlightedText = highlightedText + Text(currentCharacter).foregroundStyle(Color.textColor1)
        }
    }

    return VStack {
        highlightedText
            .font(.custom("Pretendard-Bold", size: 22))
            .lineSpacing(22 * 0.45)
            .padding(.top, 68)
            .padding(.bottom, 12)
        
        Text(context)
            .foregroundStyle(Color.textColorGray1)
            .font(.custom("Pretendard-Regular", size: 16))
            .lineSpacing(16 * 0.5)
            .padding(.bottom, 50)
        
        if image != "null" {
            Rectangle()
                .frame(width: 316, height: 316)
                .foregroundStyle(Color.black.opacity(0.3))
                .overlay {
                    Text(image)
                        .font(.custom("Pretendard-Bold", size: 22))
                        .foregroundStyle(Color.textColorGray1)
                        .opacity(0.4)
                }
        }
        
        Spacer()
    }
}
