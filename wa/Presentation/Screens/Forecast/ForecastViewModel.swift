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
    
    private let getForecastUseCase: GetForecastUseCase
    private let searchLocationUseCase: SearchLocationUseCase
    private var searchCancellable: AnyCancellable?
    
    init(
        getForecastUseCase: GetForecastUseCase,
        searchLocationUseCase: SearchLocationUseCase
    ) {
        self.getForecastUseCase = getForecastUseCase
        self.searchLocationUseCase = searchLocationUseCase
        
        setupSearchDebounce()
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
        searchQuery = location.getDisplayName()
        searchResults = []
        if let city = location.city {
            Task {
                await loadForecast(city: city, district: location.district)
            }
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
