//
//  LinearGradientExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import SwiftUI

extension LinearGradient {
    
    static var campfireViewBackground: LinearGradient {
        return LinearGradient(stops: [
            .init(color: Color.black, location: 0),
            .init(color: Color.init(hex: "100C0A").opacity(0.92), location: 0.06),
            .init(color: Color.init(hex: "211A15").opacity(0.7), location: 0.45),
            .init(color: Color.init(hex: "7B5F4D").opacity(0.19), location: 0.78),
            .init(color: Color.init(hex: "6A73AA").opacity(0), location: 1),
        ],startPoint: .top, endPoint: .bottom)
    }
    
    static var logPileRowBackground: LinearGradient {
        return LinearGradient(colors: [Color.init(hex: "3F383D").opacity(0.5), Color.init(hex: "424144").opacity(0.5)], startPoint: .top, endPoint: .bottom)
    }
    
    static var profileViewBackground: LinearGradient {
        return LinearGradient(
            stops: [
                Gradient.Stop(color: Color.init(hex: "FFC5A0").opacity(0.09), location: 0.00),
                Gradient.Stop(color: Color.init(hex: "FFEEA0").opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: -0.07),
            endPoint: UnitPoint(x: 0.5, y: 0.37)
        )
    }
    
    static var logPileDetailViewBackground: LinearGradient {
        return LinearGradient(
            stops: [
                Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09), location: 0.00),
                Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0.51), location: 0.81),
                Gradient.Stop(color: Color(red: 0.09, green: 0.09, blue: 0.09).opacity(0), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 0.2)
        )
    }
    
    static var SelectCampfiresViewBackground: LinearGradient {
        return LinearGradient(
            stops: [
            Gradient.Stop(color: Color(red: 0.24, green: 0.22, blue: 0.23), location: 0.00),
            Gradient.Stop(color: Color(red: 0.23, green: 0.22, blue: 0.24), location: 1.00),
            ],
            startPoint: UnitPoint(x: 0.5, y: 0),
            endPoint: UnitPoint(x: 0.5, y: 1)
            )
    }
}

extension EllipticalGradient {
    static var campfireViewBackground: EllipticalGradient {
        return EllipticalGradient(
            stops: [
                Gradient.Stop(color: Color.init(hex: "FFC5A0").opacity(0.2), location: 0.05),
                Gradient.Stop(color: Color.init(hex: "FFC5A0").opacity(0), location: 1)
            ],
            center: UnitPoint(x: 0.5, y: 0.75),
            startRadiusFraction: 0,
            endRadiusFraction: 0.25
        )
    }
}
