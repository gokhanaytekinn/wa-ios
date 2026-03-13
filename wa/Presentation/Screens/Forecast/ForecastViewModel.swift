import Foundation
import Combine

@MainActor
class ForecastViewModel: ObservableObject {
    @Published var forecastData: ForecastResponse? = nil
    @Published var searchResults: [LocationSearchResult] = []
    @Published var searchQuery: String = ""
    @Published var isLoading: Bool = false
    @Published var isSearching: Bool = false
    @Published var expandedSources: Set<String> = []
    @Published var isFavorite: Bool = false
    
    private let getForecastUseCase: GetForecastUseCase
    private let searchLocationUseCase: SearchLocationUseCase
    private let toggleFavoriteUseCase: ToggleFavoriteUseCase
    private let isFavoriteUseCase: IsFavoriteUseCase
    private let locationManager: LocationManager
    
    private var searchCancellable: AnyCancellable?
    private var locationCancellable: AnyCancellable?
    
    init(
        getForecastUseCase: GetForecastUseCase,
        searchLocationUseCase: SearchLocationUseCase,
        toggleFavoriteUseCase: ToggleFavoriteUseCase,
        isFavoriteUseCase: IsFavoriteUseCase,
        locationManager: LocationManager
    ) {
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
                        await self?.loadForecast(city: city, district: location.district)
                        await self?.checkFavoriteState()
                    }
                }
            }
    }
    
    func checkFavoriteState() async {
        let locationName: String
        if let selected = locationManager.selectedLocation {
            locationName = selected.getDisplayName()
        } else if let city = forecastData?.city {
            locationName = city // Fallback
        } else {
            isFavorite = false
            return
        }
        isFavorite = await isFavoriteUseCase.execute(location: locationName)
    }
    
    private func setupSearchDebounce() {
        searchCancellable = $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] query in
                if !query.isEmpty {
                    Task { await self?.search(query: query) }
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
    
    func loadForecast(city: String, district: String?) async {
        isLoading = true
        do {
            self.forecastData = try await getForecastUseCase.execute(city: city, district: district)
        } catch {
            print("Forecast load error: \(error)")
        }
        isLoading = false
    }
    
    func selectLocation(_ location: LocationSearchResult) {
        locationManager.selectedLocation = location
        searchResults = []
    }
    
    func toggleFavorite() {
        let locationToToggle: LocationSearchResult?
        
        if let selected = locationManager.selectedLocation {
            locationToToggle = selected
        } else if let data = forecastData, !data.city.isEmpty {
            locationToToggle = LocationSearchResult(
                city: data.city,
                district: data.district,
                country: nil,
                latitude: nil,
                longitude: nil
            )
        } else {
            locationToToggle = nil
        }
        
        guard let location = locationToToggle else { return }
        
        Task {
            try? await toggleFavoriteUseCase.execute(location: location)
            await checkFavoriteState()
        }
    }
    
    func toggleSource(_ sourceName: String) {
        if expandedSources.contains(sourceName) {
            expandedSources.remove(sourceName)
        } else {
            expandedSources.insert(sourceName)
        }
    }
}
