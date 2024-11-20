//
//  StringExtension.swift
//  Modak
//
//  Created by Park Junwoo on 11/13/24.
//

import SwiftUI

// 주소(String?) 체크하는 메서드
extension Optional where Wrapped == String {
    func checkAddressNilAndEmpty() -> String {
        switch self {
        case "위치 정보 없음", "":
            return "지구"
        default:
            guard let self else {
                return "지구"
            }
            return self
        }
    }
}

// 서버에서 받은 ISO8601 타입 Date 문자열을 Date로 변환하는 메서드
extension String {
    var iso8601ToDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
