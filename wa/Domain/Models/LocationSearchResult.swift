import Foundation

struct LocationSearchResult: Codable, Identifiable {
    let id = UUID()
    let city: String?
    let district: String?
    let country: String?
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case city, district, country, latitude, longitude
    }
    
    func getDisplayName() -> String {
        var parts: [String] = []
        if let city = city, !city.isEmpty {
            parts.append(city)
        }
        if let district = district, !district.isEmpty {
            parts.append(district)
        }
        
        if parts.isEmpty {
            return "Bilinmeyen Konum"
        }
        
        return parts.joined(separator: ", ")
    }
}
