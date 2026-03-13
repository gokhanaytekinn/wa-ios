import SwiftUI

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Metric"
    case fahrenheit = "Imperial"
    var id: String { self.rawValue }
    var displayName: String { self == .celsius ? "Celsius (°C)" : "Fahrenheit (°F)" }
}

enum ThemeMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"
    var id: String { self.rawValue }
}

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var isDarkMode = false
    @Published var themeMode: ThemeMode = .system
    @Published var tempUnit: TemperatureUnit = .celsius
    @Published var isLoggedIn = false
    @Published var username: String? = nil
    
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
        self.isLoggedIn = authRepository.isLoggedIn()
        self.username = authRepository.getUsername()
    }
    
    func logout() {
        Task {
            await authRepository.logout()
            self.isLoggedIn = false
            self.username = nil
        }
    }
}
