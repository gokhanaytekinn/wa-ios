import Foundation
import Combine
import SwiftUI

@MainActor
class DependencyContainer: ObservableObject {
    // Repositories
    let weatherRepository: WeatherRepository
    let favoritesRepository: FavoritesRepository
    
    // Use Cases
    let getWeatherUseCase: GetWeatherUseCase
    let getForecastUseCase: GetForecastUseCase
    let searchLocationUseCase: SearchLocationUseCase
    let toggleFavoriteUseCase: ToggleFavoriteUseCase
    
    init() {
        let apiClient = APIClient.shared
        
        self.weatherRepository = WeatherRepositoryImpl(apiClient: apiClient)
        self.favoritesRepository = FavoritesRepositoryImpl(apiClient: apiClient)
        
        self.getWeatherUseCase = GetWeatherUseCase(repository: weatherRepository)
        self.getForecastUseCase = GetForecastUseCase(repository: weatherRepository)
        self.searchLocationUseCase = SearchLocationUseCase(repository: weatherRepository)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoritesRepository)
    }
    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            getWeatherUseCase: getWeatherUseCase,
            getForecastUseCase: getForecastUseCase,
            searchLocationUseCase: searchLocationUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase
        )
    }
    
    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(favoritesRepository: favoritesRepository)
    }
    
    @MainActor
    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel()
    }
}
