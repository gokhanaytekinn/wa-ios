import Foundation

struct ToggleFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(location: String) async throws {
        let isFavorite = await repository.isFavorite(location: location)
        if isFavorite {
            try await repository.removeFavorite(location: location)
        } else {
            try await repository.addFavorite(location: location)
        }
    }
}
