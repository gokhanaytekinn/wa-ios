import Foundation

struct ForecastResponse: Codable {
    let city: String
    let district: String?
    let temperatureUnit: String?
    let source: String?
    let forecasts: [SimpleForecast]?
    let sources: [ForecastSource]?
}

struct SimpleForecast: Codable, Identifiable {
    let id = UUID()
    let date: String
    let maxTemperature: Double
    let minTemperature: Double
    let avgTemperature: Double
    let humidity: Int?
    let windSpeed: Double
    let precipitationChance: Int?
    let precipitation: Double?
    let description: String
    let weatherCode: String?
    
    enum CodingKeys: String, CodingKey {
        case date, maxTemperature, minTemperature, avgTemperature, humidity, windSpeed, precipitationChance, precipitation, description, weatherCode
    }
}

struct ForecastSource: Codable, Identifiable {
    let id = UUID()
    let source: String
    let forecasts: [SimpleForecast]
    
    enum CodingKeys: String, CodingKey {
        case source, forecasts
    }
}
