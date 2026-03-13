import SwiftUI
import Combine

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

enum AppLanguage: String, CaseIterable, Identifiable {
    case turkish = "tr"
    case english = "en"
    var id: String { self.rawValue }
    var displayName: String { self == .turkish ? "Türkçe" : "English" }
}

@MainActor
class SettingsViewModel: ObservableObject {
    @AppStorage("themeMode") var themeMode: ThemeMode = .system
    @AppStorage("tempUnit") var tempUnit: TemperatureUnit = .celsius
    @AppStorage("appLanguage") var language: AppLanguage = .turkish
    
    init() {}
}
