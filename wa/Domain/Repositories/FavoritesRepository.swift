import Foundation

protocol FavoritesRepository {
    func getFavorites() async throws -> [LocationSearchResult]
    func addFavorite(location: LocationSearchResult) async throws
    func removeFavorite(location: String) async throws
    func isFavorite(location: String) async -> Bool
}
