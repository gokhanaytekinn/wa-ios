import Foundation

class DependencyContainer: ObservableObject {
    // Repositories
    let weatherRepository: WeatherRepository
    let authRepository: AuthRepository
    let favoritesRepository: FavoritesRepository
    
    // Use Cases
    let getWeatherUseCase: GetWeatherUseCase
    let getForecastUseCase: GetForecastUseCase
    let searchLocationUseCase: SearchLocationUseCase
    let toggleFavoriteUseCase: ToggleFavoriteUseCase
    let loginUseCase: LoginUseCase
    let registerUseCase: RegisterUseCase
    
    init() {
        let apiClient = APIClient.shared
        
        self.weatherRepository = WeatherRepositoryImpl(apiClient: apiClient)
        self.authRepository = AuthRepositoryImpl(apiClient: apiClient)
        self.favoritesRepository = FavoritesRepositoryImpl(apiClient: apiClient)
        
        self.getWeatherUseCase = GetWeatherUseCase(repository: weatherRepository)
        self.getForecastUseCase = GetForecastUseCase(repository: weatherRepository)
        self.searchLocationUseCase = SearchLocationUseCase(repository: weatherRepository)
        self.toggleFavoriteUseCase = ToggleFavoriteUseCase(repository: favoritesRepository)
        self.loginUseCase = LoginUseCase(repository: authRepository)
        self.registerUseCase = RegisterUseCase(repository: authRepository)
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
    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(loginUseCase: loginUseCase, registerUseCase: registerUseCase)
    }
    
    @MainActor
    func makeFavoritesViewModel() -> FavoritesViewModel {
        FavoritesViewModel(favoritesRepository: favoritesRepository)
    }
    
    @MainActor
    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel(authRepository: authRepository)
    }
}
