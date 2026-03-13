import Foundation

protocol FavoritesRepository {
    func getFavorites() async throws -> [String]
    func addFavorite(location: String) async throws
    func removeFavorite(location: String) async throws
    func isFavorite(location: String) async -> Bool
}
