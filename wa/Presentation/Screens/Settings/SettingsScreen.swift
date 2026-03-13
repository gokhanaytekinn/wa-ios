import SwiftUI

struct SettingsScreen: View {
    @StateObject var viewModel: SettingsViewModel
    @State private var showLogin = false
    
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
                
                Section(header: Text("Hesap")) {
                    if viewModel.isLoggedIn {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(viewModel.username ?? "Kullanıcı")
                                    .fontWeight(.bold)
                                Text("Giriş yapıldı")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        Button(role: .destructive, action: viewModel.logout) {
                            Text("Çıkış Yap")
                        }
                    } else {
                        Button(action: { showLogin = true }) {
                            Text("Giriş Yap / Kayıt Ol")
                                .fontWeight(.medium)
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
            .sheet(isPresented: $showLogin) {
                LoginScreen(viewModel: viewModel.authRepository as? LoginViewModel ?? LoginViewModel(loginUseCase: DependencyContainer().loginUseCase, registerUseCase: DependencyContainer().registerUseCase))
            }
        }
    }
}
