import Foundation

class FavoritesRepositoryImpl: FavoritesRepository {
    private let apiClient: APIClient
    private let userDefaults = UserDefaults.standard
    private let favoritesKey = "favorite_locations_data"
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func getFavorites() async throws -> [LocationSearchResult] {
        if let data = userDefaults.data(forKey: favoritesKey) {
            do {
                return try JSONDecoder().decode([LocationSearchResult].self, from: data)
            } catch {
                print("Favorites decode error: \(error)")
                return []
            }
        }
        return []
    }
    
    func addFavorite(location: LocationSearchResult) async throws {
        var favorites = try await getFavorites()
        let displayName = location.getDisplayName()
        
        if !favorites.contains(where: { $0.getDisplayName() == displayName }) {
            favorites.append(location)
            if let data = try? JSONEncoder().encode(favorites) {
                userDefaults.set(data, forKey: favoritesKey)
            }
        }
    }
    
    func removeFavorite(location: String) async throws {
        var favorites = try await getFavorites()
        if let index = favorites.firstIndex(where: { $0.getDisplayName() == location }) {
            favorites.remove(at: index)
            if let data = try? JSONEncoder().encode(favorites) {
                userDefaults.set(data, forKey: favoritesKey)
            }
        }
    }
    
    func isFavorite(location: String) async -> Bool {
        do {
            let favorites = try await getFavorites()
            return favorites.contains(where: { $0.getDisplayName() == location })
        } catch {
            return false
        }
    }
}
