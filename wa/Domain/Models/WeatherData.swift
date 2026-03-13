import Foundation

struct WeatherData: Codable, Identifiable {
    let id = UUID()
    let city: String?
    let district: String?
    let temperature: Double?
    let feelsLike: Double?
    let humidity: Int?
    let windSpeed: Double?
    let precipitation: Double?
    let description: String?
    let weatherCode: String?
    let source: String?
    let timestamp: FlexibleTimestamp?
    let sources: [WeatherSource]?
    
    enum CodingKeys: String, CodingKey {
        case city, district, temperature, humidity, precipitation, description, source, timestamp, sources
        case feelsLike = "feelsLike"
        case windSpeed = "windSpeed"
        case weatherCode = "weatherCode"
    }
}

struct FlexibleTimestamp: Codable {
    let value: Int64
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int64.self) {
            value = intValue
        } else if let stringValue = try? container.decode(String.self) {
            // ISO 8601 parsing logic
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
            
            if let date = isoFormatter.date(from: stringValue) {
                value = Int64(date.timeIntervalSince1970 * 1000)
            } else {
                // Fallback for non-standard ISO formats
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                let formats = ["yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"]
                
                var parsedDate: Date? = nil
                for format in formats {
                    dateFormatter.dateFormat = format
                    if let date = dateFormatter.date(from: stringValue) {
                        parsedDate = date
                        break
                    }
                }
                
                if let date = parsedDate {
                    value = Int64(date.timeIntervalSince1970 * 1000)
                } else {
                    // Try to parse as a stringified integer
                    if let int64Value = Int64(stringValue) {
                        value = int64Value
                    } else {
                        value = 0
                    }
                }
            }
        } else {
            throw DecodingError.typeMismatch(Int64.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int64 or String for timestamp"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
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
    let sourceName: String?
    let current: CurrentWeather?
    let forecast: [ForecastDay]?
    
    enum CodingKeys: String, CodingKey {
        case sourceName = "source_name"
        case current, forecast
    }
}

struct CurrentWeather: Codable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int?
    let windSpeed: Double
    let precipitation: Double
    let pressure: Int
    let visibility: Double
    let uvIndex: Int?
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
    let condition: String?
    let icon: String?
    let precipitationChance: Int?
    let humidity: Int?
    
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
    let precipitationChance: Int?
    
    enum CodingKeys: String, CodingKey {
        case time, temperature, condition, icon
        case precipitationChance = "precipitation_chance"
    }
}
