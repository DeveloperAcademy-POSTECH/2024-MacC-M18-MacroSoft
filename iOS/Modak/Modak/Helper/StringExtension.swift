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

// presignedURL String에서 webpURLName을 추출하는 메서드
extension String {
    var webpURLName: String {
        do {
            // .com/ 이후부터 .webp까지 String을 추출하는 정규식 패턴
            let pattern = "(?<=\\.com/).*?\\.webp"
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(self.startIndex..<self.endIndex, in: self)
            
            if let matchString = regex.firstMatch(in: self, range: range) {
                if let matchRange = Range(matchString.range, in: self) {
                    return String(self[matchRange])
                } else {
                    return ""
                }
            } else {
                return ""
            }
        } catch {
            return ""
        }
    }
}
