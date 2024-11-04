//
//  ModakApp.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import Firebase

@main
struct ModakApp: App {
    
    init() {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .modelContainer(for: [PrivateLog.self, PrivateLogImage.self])
        }
    }
}
