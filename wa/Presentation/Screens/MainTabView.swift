import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var container: DependencyContainer
    @EnvironmentObject var localizer: Localizer
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeScreen(viewModel: container.makeHomeViewModel())
                .tabItem {
                    Label(localizer.string(.weather), systemImage: "cloud.sun.fill")
                }
                .tag(0)
            
            // Forecast tab will be added here properly after screen implementation
            ForecastScreen(viewModel: container.makeForecastViewModel())
                .tabItem {
                    Label(localizer.string(.forecast), systemImage: "calendar")
                }
                .tag(1)
            
            FavoritesScreen(viewModel: container.makeFavoritesViewModel()) { location in
                selectedTab = 0
            }
            .tabItem {
                Label(localizer.string(.favorites), systemImage: "heart.fill")
            }
            .tag(2)
            
            SettingsScreen(viewModel: container.makeSettingsViewModel())
                .tabItem {
                    Label(localizer.string(.settings), systemImage: "gearshape.fill")
                }
                .tag(3)
        }
    }
}
