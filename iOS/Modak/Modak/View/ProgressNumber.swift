//
//  OrganizePhotoProgressNumber.swift
//  Modak
//
//  Created by kimjihee on 10/8/24.
//

import SwiftUI

struct ProgressNumber: View {
    let currentCount: Int
    let totalCount: Int

    var body: some View {
        HStack {
            Spacer()
            
            HStack {
                Text("\(String(currentCount)) ")
                    .foregroundStyle(Color.mainColor1)
                    .font(.custom("Pretendard-SemiBold", size: 20))
                + Text("/ \(String(totalCount))")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundStyle(Color.textColorGray1)
                    .kerning(14 * 0.01)
                + Text(" ")
                    .font(.custom("Pretendard-Regular", size: 13))
                    .foregroundStyle(Color.textColorGray1)
                    .kerning(13 * 0.01)
                + Text("장")
                    .font(.custom("Pretendard-Bold", size: 14))
                    .foregroundStyle(Color.textColorGray1)
                    .kerning(14 * 0.01)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(backgroundView)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private var backgroundView: some View {
        if currentCount >= totalCount {
            RoundedRectangle(cornerRadius: 42)
                .fill(Color.textBackgroundRedGray.opacity(0.01))
                .overlay(
                    RoundedRectangle(cornerRadius: 42)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.69, green: 0.57, blue: 0.57).opacity(0),
                                    Color(red: 0.91, green: 0.73, blue: 0.73).opacity(0.78)
                                ]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ).opacity(0.1)
                        )
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.58, blue: 0.54),
                                    Color(red: 1.0, green: 0.70, blue: 0.87)
                                ]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ),
                            lineWidth: 1
                        )
                        .overlay(
                            // Inner shadow effect
                            RoundedRectangle(cornerRadius: 42)
                                .stroke(Color(red: 1.0, green: 0.93, blue: 0.92).opacity(0.1), lineWidth: 7)
                                .blur(radius: 7)
                                .offset(x: 0, y: 0)
                                .mask(RoundedRectangle(cornerRadius: 42))
                        )
                )
        } else {
            RoundedRectangle(cornerRadius: 42)
                .fill(Color.textBackgroundRedGray.opacity(0.1))
        }
    }
}

#Preview {
    ProgressNumber(currentCount: 10245, totalCount: 10245)
}




