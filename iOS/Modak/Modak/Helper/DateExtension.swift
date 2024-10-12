//
//  DateExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import Foundation

extension Date {
    
    var logPileRowTitleDayFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: self)
    }
    
    var logPileRowTitleTimeFormat: String {
        let formatter = DateFormatter()
        // TODO: Preview에서 locale 설정을 안 하니 오전/오후가 안나와서 추가
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        return formatter.string(from: self)
    }
}
