import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var container: DependencyContainer
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen(viewModel: container.makeHomeViewModel())
                .tabItem {
                    Label("Hava Durumu", systemImage: "cloud.sun.fill")
                }
                .tag(0)
            
            FavoritesScreen(viewModel: container.makeFavoritesViewModel()) { location in
                // Handle location selection - switch to home and load weather
                selectedTab = 0
                // We'd need a more robust way to pass location to HomeViewModel 
                // but for this MVP, we'll assume location is passed via global state or similar
            }
            .tabItem {
                Label("Favoriler", systemImage: "heart.fill")
            }
            .tag(1)
            
            SettingsScreen(viewModel: container.makeSettingsViewModel())
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
    }
}
