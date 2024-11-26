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
        AvatarData(name: "avatar1", position: SCNVector3(0, 0, 0), rotation: SCNVector4(0, 0, 1, 0.5)),
    ]
    
    static let sample2 = [
        AvatarData(name: "avatar1", position: SCNVector3(1.2, 1.2, 0), rotation: SCNVector4(0, 0, 1, -0.6)),
        AvatarData(name: "avatar2", position: SCNVector3(-1.0, 0.7, 0), rotation: SCNVector4(0, 0, 1, 0.6)),
        AvatarData(name: "avatar3", position: SCNVector3(-0.3, 1.5, 0), rotation: SCNVector4(0, 0, 1, 0)),
        AvatarData(name: "avatar4", position: SCNVector3(1.6, 0.1, 0), rotation: SCNVector4(0, 0, 1, -1.2)),
        AvatarData(name: "avatar5", position: SCNVector3(-1.5, 0.3, 0), rotation: SCNVector4(0, 0, 1, 1.4)),
        AvatarData(name: "avatar6", position: SCNVector3(0.6, 2.3, 0), rotation: SCNVector4(0, 0, 1, -0.3))
    ]
}
