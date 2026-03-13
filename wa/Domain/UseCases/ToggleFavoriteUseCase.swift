import Foundation

struct ToggleFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(location: LocationSearchResult) async throws {
        let displayName = location.getDisplayName()
        let isFavorite = await repository.isFavorite(location: displayName)
        if isFavorite {
            try await repository.removeFavorite(location: displayName)
        } else {
            try await repository.addFavorite(location: location)
        }
    }
}
