import Foundation

struct LoginUseCase {
    private let repository: AuthRepository
    
    init(repository: AuthRepository) {
        self.repository = repository
    }
    
    func execute(request: LoginRequest) async throws -> AuthResponse {
        try await repository.login(request: request)
    }
}
