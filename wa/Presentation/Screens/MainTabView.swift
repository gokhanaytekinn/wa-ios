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
            
            ForecastScreen(viewModel: container.makeForecastViewModel())
                .tabItem {
                    Label(localizer.string(.forecast), systemImage: "calendar")
                }
                .tag(1)
            
            FavoritesScreen(viewModel: container.makeFavoritesViewModel()) { location in
                LocationManager.shared.selectedLocation = location
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
