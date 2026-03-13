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
    let isFavoriteUseCase: IsFavoriteUseCase
    
    init() {
        let apiClient = APIClient.shared
        
        self.weatherRepository = WeatherRepositoryImpl(apiClient: apiClient)
        self.favoritesRepository = FavoritesRepositoryImpl(apiClient: apiClient)
        
        self.getWeatherUseCase = GetWeatherUseCase(repository: weatherRepository)
        self.getForecastUseCase = GetForecastUseCase(repository: weatherRepository)
        self.searchLocationUseCase = SearchLocationUseCase(repository: weatherRepository)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoritesRepository)
        self.isFavoriteUseCase = IsFavoriteUseCase(repository: favoritesRepository)
    }
    
    @MainActor
    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(
            getWeatherUseCase: getWeatherUseCase,
            getForecastUseCase: getForecastUseCase,
            searchLocationUseCase: searchLocationUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            locationManager: LocationManager.shared
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
    
    @MainActor
    func makeForecastViewModel() -> ForecastViewModel {
        ForecastViewModel(
            getForecastUseCase: getForecastUseCase,
            searchLocationUseCase: searchLocationUseCase,
            toggleFavoriteUseCase: toggleFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            locationManager: LocationManager.shared
        )
    }
}
