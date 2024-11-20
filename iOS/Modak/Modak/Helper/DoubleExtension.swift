//
//  DoubleExtension.swift
//  Modak
//
//  Created by Park Junwoo on 11/20/24.
//
import Foundation

extension Double {
    func roundToDecimalPlaces(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
