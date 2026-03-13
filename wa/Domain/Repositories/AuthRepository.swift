import Foundation

protocol AuthRepository {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterRequest) async throws -> AuthResponse
    func logout() async
    func getUsername() -> String?
    func getAccessToken() -> String?
    func isLoggedIn() -> Bool
}

// DTOs for Auth
struct LoginRequest: Codable {
    let username: String
    let password: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    let id: String
    let email: String
    let name: String
    let tier: Int
    let notificationsEnabled: Bool
    let language: String
    let createdAt: String
    let token: String?
}
