//
//  TextExtension.swift
//  Modak
//
//  Created by Park Junwoo on 11/5/24.
//

import SwiftUI

extension Text {
    // 특정 글자 수 이상 ...으로 표시하는 Text Extension
    init(_ text: String, textLimit: Int){
        
        let truncatedText: String
        if text.count > textLimit {
            let endIndex = text.index(text.startIndex, offsetBy: textLimit)
            truncatedText = String(text[..<endIndex]) + "..."
        } else {
            truncatedText = text
        }
        
        self.init(truncatedText)
    }
}
