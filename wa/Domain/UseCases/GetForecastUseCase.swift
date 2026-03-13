import Foundation

struct GetForecastUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(city: String, district: String?, days: Int = 5) async throws -> ForecastResponse {
        try await repository.getForecast(city: city, district: district, days: days)
    }
}
