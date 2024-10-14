//
//  LinearGradientExtension.swift
//  Modak
//
//  Created by Park Junwoo on 10/12/24.
//

import SwiftUI

// TODO: 사용하는 색 Asset Catalog에 넣기
extension LinearGradient {
    
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
}
