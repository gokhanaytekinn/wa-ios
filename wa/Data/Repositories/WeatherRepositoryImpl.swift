import Foundation

class WeatherRepositoryImpl: WeatherRepository {
    private let apiClient: APIClient
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCurrentWeather(city: String, district: String?) async throws -> WeatherData {
        var params = ["city": city]
        if let district = district {
            params["district"] = district
        }
        return try await apiClient.request(endpoint: "weather/current", queryParams: params)
    }
    
    func getForecast(city: String, district: String?, days: Int) async throws -> ForecastResponse {
        var params = ["city": city, "days": String(days)]
        if let district = district {
            params["district"] = district
        }
        return try await apiClient.request(endpoint: "weather/forecast", queryParams: params)
    }
    
    func searchLocations(query: String) async throws -> [LocationSearchResult] {
        return try await apiClient.request(endpoint: "location/search", queryParams: ["query": query])
    }
}
