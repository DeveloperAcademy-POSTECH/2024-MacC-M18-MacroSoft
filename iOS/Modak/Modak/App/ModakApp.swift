//
//  ModakApp.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

@main
struct ModakApp: App {
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .modelContainer(for: [Log.self, PhotoMetadata.self])
        }
    }
}
