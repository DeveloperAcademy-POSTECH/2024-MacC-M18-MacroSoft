//
//  PageIndicator.swift
//  Modak
//
//  Created by kimjihee on 10/7/24.
//

import SwiftUI

struct PageIndicator: View {
    var currentPage: Int
    var totalPages: Int
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 7, height: 7)
                    .background(index == currentPage ? Color(red: 0.71, green: 0.52, blue: 0.50) : Color(red: 0.38, green: 0.35, blue: 0.35))
            }
        }
        .frame(width: 33, height: 7)
    }
}
