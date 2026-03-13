import Foundation
import Combine

protocol WeatherRepository {
    func getCurrentWeather(city: String, district: String?) async throws -> WeatherData
    func getForecast(city: String, district: String?, days: Int) async throws -> ForecastResponse
    func searchLocations(query: String) async throws -> [LocationSearchResult]
}
