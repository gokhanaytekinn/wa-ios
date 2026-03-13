import Foundation
import SwiftUI

class WeatherRepositoryImpl: WeatherRepository {
    private let apiClient: APIClient
    
    // We read from UserDefaults to get the latest settings
    private var language: String {
        UserDefaults.standard.string(forKey: "appLanguage") ?? "tr"
    }
    
    private var unit: String {
        UserDefaults.standard.string(forKey: "tempUnit") == "Imperial" ? "F" : "C"
    }
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getCurrentWeather(city: String, district: String?) async throws -> WeatherData {
        var params = [
            "city": city,
            "lang": language,
            "unit": unit
        ]
        if let district = district {
            params["district"] = district
        }
        return try await apiClient.request(endpoint: "weather/current", queryParams: params)
    }
    
    func getForecast(city: String, district: String?, days: Int) async throws -> ForecastResponse {
        var params = [
            "city": city, 
            "days": String(days),
            "lang": language,
            "unit": unit
        ]
        if let district = district {
            params["district"] = district
        }
        return try await apiClient.request(endpoint: "weather/forecast", queryParams: params)
    }
    
    func searchLocations(query: String) async throws -> [LocationSearchResult] {
        return try await apiClient.request(endpoint: "location/search", queryParams: [
            "query": query,
            "language": language
        ])
    }
}
