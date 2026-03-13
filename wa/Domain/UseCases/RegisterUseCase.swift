import Foundation

struct RegisterUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(request: RegisterRequest) async throws -> AuthResponse {
        try await repository.register(request: request)
    }
}
