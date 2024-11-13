//
//  LogPileBackground.swift
//  Modak
//
//  Created by Park Junwoo on 11/8/24.
//

import SwiftUI

struct LogPileBackground: View {
    var body: some View {
        Color.backgroundLogPile
        
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.08, green: 0.06, blue: 0.08).opacity(0.5), location: 0.00),
                Gradient.Stop(color: Color(red: 0.15, green: 0.15, blue: 0.15).opacity(0.5), location: 0.36),
                Gradient.Stop(color: Color(red: 0.24, green: 0.23, blue: 0.23).opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
        
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.93, blue: 0.63).opacity(0), location: 0.65),
                Gradient.Stop(color: Color(red: 1, green: 0.77, blue: 0.63).opacity(0.05), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
        )
    }
}
