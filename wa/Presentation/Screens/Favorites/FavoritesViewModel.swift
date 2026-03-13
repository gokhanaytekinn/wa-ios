import Foundation
import Combine

@MainActor
class FavoritesViewModel: ObservableObject {
    @Published var favorites: [String] = []
    @Published var isLoading = false
    
    private let favoritesRepository: FavoritesRepository
    
    init(favoritesRepository: FavoritesRepository) {
        self.favoritesRepository = favoritesRepository
    }
    
    func loadFavorites() async {
        isLoading = true
        do {
            favorites = try await favoritesRepository.getFavorites()
        } catch {
            print("Favorites load error: \(error)")
        }
        isLoading = false
    }
    
    func removeFavorite(location: String) async {
        do {
            try await favoritesRepository.removeFavorite(location: location)
            await loadFavorites()
        } catch {
            print("Remove favorite error: \(error)")
        }
    }
}
