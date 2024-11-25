//
//  AvatarModel.swift
//  Modak
//
//  Created by kimjihee on 11/25/24.
//

import SceneKit

struct AvatarData {
    let name: String
    let position: SCNVector3
    let rotation: SCNVector4

    static let sample = [
        AvatarData(name: "avatar1", position: SCNVector3(0, 0, 0), rotation: SCNVector4(0, 0, 1, 0.5))
    ]
}
