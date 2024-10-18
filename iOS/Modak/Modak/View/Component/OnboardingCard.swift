//
//  OnboardingView.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI

public func onboardingCard(title: String, titleHighlightRanges: [ClosedRange<Int>], context: String, image: String, imagePadding: CGFloat) -> some View {
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
            .padding([.top, .bottom], 10)
        
        Text(context)
            .foregroundStyle(Color.textColorGray1)
            .font(.custom("Pretendard-Regular", size: 16))
            .lineSpacing(16 * 0.5)
            .padding(.bottom, imagePadding)
        
        if image != "null" {
            GeometryReader { geometry in
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(8)
                    .frame(width: geometry.size.width)
            }
        }
        
        Spacer()
    }
}
