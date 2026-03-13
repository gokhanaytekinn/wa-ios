import Foundation

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let location: Location?
    let sources: [WeatherSource]?
    let timestamp: Int64
    
    enum CodingKeys: String, CodingKey {
        case location, sources, timestamp
    }
}

struct Location: Codable {
    let city: String
    let district: String?
    let country: String
    let latitude: Double
    let longitude: Double
}

struct WeatherSource: Codable, Identifiable {
    let id = UUID()
    let sourceName: String
    let current: CurrentWeather
    let forecast: [ForecastDay]?
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case current, forecast
    }
}

struct CurrentWeather: Codable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let precipitation: Double
    let pressure: Int
    let visibility: Double
    let uvIndex: Int
    let condition: String
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case temperature
        case feelsLike = "feels_like"
        case humidity
        case windSpeed = "wind_speed"
        case precipitation, pressure, visibility
        case uvIndex = "uv_index"
        case condition, icon
    }
}

struct ForecastDay: Codable, Identifiable {
    let id = UUID()
    let date: String
    let day: DayWeather
    let hourly: [HourlyWeather]?
    
    enum CodingKeys: String, CodingKey {
        case date, day, hourly
    }
}

struct DayWeather: Codable {
    let maxTemp: Double
    let minTemp: Double
    let avgTemp: Double
    let condition: String
    let icon: String?
    let precipitationChance: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case maxTemp = "max_temp"
        case minTemp = "min_temp"
        case avgTemp = "avg_temp"
        case condition, icon
        case precipitationChance = "precipitation_chance"
        case humidity
    }
}

struct HourlyWeather: Codable, Identifiable {
    let id = UUID()
    let time: String
    let temperature: Double
    let condition: String
    let icon: String?
    let precipitationChance: Int
    
    enum CodingKeys: String, CodingKey {
        case time, temperature, condition, icon
        case precipitationChance = "precipitation_chance"
    }
}
