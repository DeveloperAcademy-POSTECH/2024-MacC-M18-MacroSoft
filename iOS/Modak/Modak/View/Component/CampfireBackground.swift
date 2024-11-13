//
//  CampfireBackground.swift
//  Modak
//
//  Created by Park Junwoo on 11/8/24.
//

import SwiftUI

struct CampfireBackground: View {
    var body: some View {
        Color.backgroundDefault
        LinearGradient.campfireViewBackground
        EllipticalGradient.campfireViewBackground
            .rotationEffect(.degrees(90), anchor: UnitPoint(x: 0.5, y: 0.75))
    }
}
