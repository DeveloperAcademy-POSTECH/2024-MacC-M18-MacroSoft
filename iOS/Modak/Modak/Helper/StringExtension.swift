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
