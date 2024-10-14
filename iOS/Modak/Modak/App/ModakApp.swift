//
//  ModakApp.swift
//  Modak
//
//  Created by kimjihee on 10/2/24.
//

import SwiftUI

@main
struct ModakApp: App {
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isSkipRegister {
                ContentView()
            } else {
                RegisterView()
            }
        }
    }
}
