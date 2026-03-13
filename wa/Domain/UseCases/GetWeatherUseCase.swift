import Foundation

struct GetWeatherUseCase {
    private let repository: WeatherRepository
    
    init(repository: WeatherRepository) {
        self.repository = repository
    }
    
    func execute(city: String, district: String?) async throws -> WeatherData {
        try await repository.getCurrentWeather(city: city, district: district)
    }
}
