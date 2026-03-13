import Foundation

class FavoritesRepositoryImpl: FavoritesRepository {
    private let apiClient: APIClient
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favorite_locations"
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getFavorites() async throws -> [String] {
        // In this app, favorites are stored per-user on backend, 
        // but for simplicity and offline access, we'll sync with local storage
        if let localFavorites = userDefaults.stringArray(forKey: favoritesKey) {
            return localFavorites
        }
        
        // If we want backend persistence:
        // let response: [String] = try await apiClient.request(endpoint: "favorites")
        // userDefaults.set(response, forKey: favoritesKey)
        // return response
        
        return []
    }
    
    func addFavorite(location: String) async throws {
        var favorites = try await getFavorites()
        if !favorites.contains(location) {
            favorites.append(location)
            userDefaults.set(favorites, forKey: favoritesKey)
            
            // Backend sync:
            // try await apiClient.request(endpoint: "favorites", method: "POST", body: JSONEncoder().encode(["location": location]))
        }
    }
    
    func removeFavorite(location: String) async throws {
        var favorites = try await getFavorites()
        if let index = favorites.firstIndex(of: location) {
            favorites.remove(at: index)
            userDefaults.set(favorites, forKey: favoritesKey)
            
            // Backend sync:
            // try await apiClient.request(endpoint: "favorites/\(location)", method: "DELETE")
        }
    }
    
    func isFavorite(location: String) async -> Bool {
        do {
            let favorites = try await getFavorites()
            return favorites.contains(location)
        } catch {
            return false
        }
    }
}
