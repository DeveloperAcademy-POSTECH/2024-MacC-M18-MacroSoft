//
//  NetworkError.swift
//  Modak
//
//  Created by kimjihee on 11/6/24.
//

import SwiftUI

struct NetworkMonitorAlert: View {
    var body: some View {
        HStack {
            Image(systemName: "wifi.exclamationmark")
            Text("인터넷 연결을 확인해주세요")
                .font(Font.custom("Pretendard-Regular", size: 14))
        }
        .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
        .background(Color.errorRed)
        .foregroundColor(Color.white)
        .cornerRadius(14)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

#Preview {
    NetworkMonitorAlert()
}
