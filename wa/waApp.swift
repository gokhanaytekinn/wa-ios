//
//  waApp.swift
//  wa
//
//  Created by Gökhan Aytekin on 13.03.2026.
//

import SwiftUI

@main
struct waApp: App {
    @StateObject private var container = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(container)
        }
    }
}
