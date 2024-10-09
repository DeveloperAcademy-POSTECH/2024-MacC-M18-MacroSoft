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
            .background(RoundedRectangle(cornerRadius: 42).fill(Color.textBackgroundRedGray.opacity(0.1)))
            
            Spacer()
        }
    }
}

#Preview {
    ProgressNumber(currentCount: 10, totalCount: 10245)
}




