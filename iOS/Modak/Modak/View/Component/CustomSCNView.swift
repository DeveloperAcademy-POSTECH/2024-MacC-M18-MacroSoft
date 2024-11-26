//
//  CustomSCNView.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SceneKit
import SwiftUI

struct CustomSCNView: UIViewRepresentable {
    let scene: SCNScene

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = scene
        scnView.backgroundColor = .clear
        scnView.allowsCameraControl = false
        scnView.autoenablesDefaultLighting = true
        return scnView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}
}
