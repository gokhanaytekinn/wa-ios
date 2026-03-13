import SwiftUI

struct SettingsScreen: View {
    @StateObject var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Görünüm")) {
                    Picker("Tema", selection: $viewModel.themeMode) {
                        ForEach(ThemeMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    
                    Picker("Sıcaklık Birimi", selection: $viewModel.tempUnit) {
                        ForEach(TemperatureUnit.allCases) { unit in
                            Text(unit.displayName).tag(unit)
                        }
                    }
                }
                
                Section(header: Text("Dil")) {
                    Picker("Uygulama Dili", selection: $viewModel.language) {
                        ForEach(AppLanguage.allCases) { lang in
                            Text(lang.displayName).tag(lang)
                        }
                    }
                }
                
                Section(header: Text("Hakkında")) {
                    HStack {
                        Text("Versiyon")
                        Spacer()
                        Text("1.5.0")
                            .foregroundColor(.secondary)
                    }
                    Text("Gizlilik Politikası")
                    Text("Kullanım Koşulları")
                }
            }
            .navigationTitle("Ayarlar")
        }
    }
}
