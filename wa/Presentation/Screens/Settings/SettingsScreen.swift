import SwiftUI

struct SettingsScreen: View {
    @StateObject var viewModel: SettingsViewModel
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(localizer.string(.theme))) {
                    Picker(localizer.string(.theme), selection: $viewModel.themeMode) {
                        ForEach(ThemeMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    
                    Picker(localizer.string(.tempUnit), selection: $viewModel.tempUnit) {
                        ForEach(TemperatureUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                }
                
                Section(header: Text(localizer.string(.language))) {
                    Picker(localizer.string(.language), selection: $viewModel.language) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                }
                
                Section(header: Text(localizer.string(.version))) {
                    HStack {
                        Text(localizer.string(.version))
                        Spacer()
                        Text("1.5.0")
                            .foregroundColor(.secondary)
                    }
                    Text(localizer.string(.privacy))
                    Text(localizer.string(.terms))
                }
            }
            .navigationTitle(localizer.string(.settings))
        }
    }
}
