import SwiftUI

@main
struct waApp: App {
    @StateObject private var container = DependencyContainer()
    @AppStorage("themeMode") var themeMode: ThemeMode = .system
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(container)
                .preferredColorScheme(colorScheme)
                .animation(.easeInOut, value: themeMode)
        }
    }
    
    private var colorScheme: ColorScheme? {
        switch themeMode {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
