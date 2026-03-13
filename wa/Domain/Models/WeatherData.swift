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
    let source: String?
    let temperature: Double?
    let feelsLike: Double?
    let humidity: Int?
    let windSpeed: Double?
    let precipitation: Double?
    let description: String?
    let weatherCode: String?
    let timestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case source, temperature, humidity, precipitation, description, timestamp
        case feelsLike = "feelsLike"
        case windSpeed = "windSpeed"
        case weatherCode = "weatherCode"
    }
}


