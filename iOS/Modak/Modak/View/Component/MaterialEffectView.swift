//
//  MaterialEffectView.swift
//  Modak
//
//  Created by Park Junwoo on 11/13/24.
//

import SwiftUI

struct MaterialEffectView: UIViewRepresentable {
    var effect: UIVisualEffect
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}
