import Foundation

struct SearchLocationUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(query: String) async throws -> [LocationSearchResult] {
        if query.trimmingCharacters(in: .whitespaces).count < 3 {
            return []
        }
        return try await repository.searchLocations(query: query)
    }
}
