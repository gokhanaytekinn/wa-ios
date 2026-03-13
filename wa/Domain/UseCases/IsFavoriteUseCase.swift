import Foundation

struct IsFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(location: String) async -> Bool {
        return await repository.isFavorite(location: location)
    }
}
