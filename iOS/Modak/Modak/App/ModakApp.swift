//
//  ModakApp.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI
import Firebase
import Kingfisher

@main
struct ModakApp: App {
    @StateObject private var logPileViewModel: LogPileViewModel
    = LogPileViewModel()
    @StateObject private var selectMergeLogsViewModel: SelectMergeLogsViewModel = SelectMergeLogsViewModel()
    @StateObject private var avatarViewModel: AvatarViewModel = AvatarViewModel()
    init() {
        // Kingfisher 만료 설정
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .never
        
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .modelContainer(for: [PrivateLog.self, PrivateLogImage.self, Campfire.self])
                .environmentObject(logPileViewModel)
                .environmentObject(selectMergeLogsViewModel)
                .environmentObject(avatarViewModel)
        }
    }
}
