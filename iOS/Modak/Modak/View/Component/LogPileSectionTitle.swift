//
//  LogPileSectionTitle.swift
//  Modak
//
//  Created by Park Junwoo on 11/8/24.
//

import SwiftUI

struct LogPileSectionTitle: View {
    private(set) var date: Date
    // TODO: calendar는 초기값을 넣어주는 형태라서 private만 줬는데 오류가 발생해서 private(set)으로 변경...왜...?
    private(set) var calendar: Calendar = .current
    
    var body: some View {
        // TODO: Text 표시하는 로직 수정
        // TODO: date가 혹시라도 nil이거나 dateComponents를 통해 나온 날짜 값이 nil인 경우 처리
        Group {
            if let year = calendar.dateComponents([.year], from: date).year, let month = calendar.dateComponents([.month], from: date).month{
                Text("\(year.description)년 ")
                    .foregroundStyle(.textColor4)
                    .font(Font.custom("Pretendard-Bold", size: 21))
                +
                Text("\(month)월")
                    .foregroundStyle(.textColor2)
                    .font(Font.custom("Pretendard-Medium", size: 21))
            } else {
                Text("년 ")
                    .foregroundStyle(.textColor4)
                    .font(Font.custom("Pretendard-Bold", size: 21))
                +
                Text("월")
                    .foregroundStyle(.textColor2)
                    .font(Font.custom("Pretendard-Medium", size: 21))
            }
        }
        .padding(.leading, 24)
    }
}
