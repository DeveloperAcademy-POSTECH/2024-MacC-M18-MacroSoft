//
//  Untitled.swift
//  Modak
//
//  Created by Park Junwoo on 10/14/24.
//
import SwiftUI

struct CoordinatorView: View {
    @AppStorage("isSkipRegister") var isSkipRegister: Bool = false
    
    var body: some View {
        if isSkipRegister {
            ContentView()
        } else {
            RegisterView()
        }
    }
}
