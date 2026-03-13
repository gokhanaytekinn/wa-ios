import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var weather: WeatherData? = nil
    @Published var forecasts: [SimpleForecast] = []
    @Published var searchResults: [LocationSearchResult] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    @Published var errorMessage: String? = nil
    @Published var expandedSources: Set<UUID> = []
    @Published var isFavorite: Bool = false
    
    private let getWeatherUseCase: GetWeatherUseCase
    private let getForecastUseCase: GetForecastUseCase
    private let searchLocationUseCase: SearchLocationUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    private let locationManager: LocationManager
    
    private var searchCancellable: AnyCancellable?
    private var locationCancellable: AnyCancellable?
    
    init(
        getWeatherUseCase: GetWeatherUseCase,
        getForecastUseCase: GetForecastUseCase,
        searchLocationUseCase: SearchLocationUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        isFavoriteUseCase: IsFavoriteUseCase,
        locationManager: LocationManager
    ) {
        self.getWeatherUseCase = getWeatherUseCase
        self.getForecastUseCase = getForecastUseCase
        self.searchLocationUseCase = searchLocationUseCase
        self.toggleFavoriteUseCase = toggleFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.locationManager = locationManager
        
        setupSearchDebounce()
        setupLocationSubscription()
    }
    
    private func setupLocationSubscription() {
        locationCancellable = locationManager.$selectedLocation
            .compactMap { $0 }
            .sink { [weak self] location in
                self?.searchQuery = location.getDisplayName()
                if let city = location.city {
                    Task {
                        await self?.loadWeather(city: city, district: location.district)
                        await self?.checkFavoriteState()
                    }
                }
            }
    }
    
    func checkFavoriteState() async {
        guard let city = weather?.city else { 
            isFavorite = false
            return 
        }
        isFavorite = await isFavoriteUseCase.execute(location: city)
    }
    
    private func setupSearchDebounce() {
        searchCancellable = $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                if !query.isEmpty {
                    Task {
                        await self?.search(query: query)
                    }
                } else {
                    self?.searchResults = []
                }
            }
    }
    
    func search(query: String) async {
        isSearching = true
        do {
            searchResults = try await searchLocationUseCase.execute(query: query)
        } catch {
            print("Search error: \(error)")
        }
        isSearching = false
    }
    
    func loadWeather(city: String, district: String?) async {
        isLoading = true
        errorMessage = nil
        do {
            async let weatherData = getWeatherUseCase.execute(city: city, district: district)
            async let forecastData = getForecastUseCase.execute(city: city, district: district)
            
            self.weather = try await weatherData
            self.forecasts = try await forecastData.forecasts ?? []
        } catch {
            errorMessage = "Hava durumu yüklenemedi: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func selectLocation(_ location: LocationSearchResult) {
        locationManager.selectedLocation = location
        searchResults = []
    }
    
    func toggleFavorite() {
        guard let city = weather?.city else { return }
        Task {
            try? await toggleFavoriteUseCase.execute(location: city)
            await checkFavoriteState()
        }
    }
    
    func toggleSource(_ id: UUID) {
        if expandedSources.contains(id) {
            expandedSources.remove(id)
        } else {
            expandedSources.insert(id)
        }
    }
}
