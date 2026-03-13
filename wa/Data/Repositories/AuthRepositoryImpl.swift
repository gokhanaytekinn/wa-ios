import Foundation

class AuthRepositoryImpl: AuthRepository {
    private let apiClient: APIClient
    private let userDefaults = UserDefaults.standard
    
    private let tokenKey = "access_token"
    private let usernameKey = "username"
    private let userDataKey = "user_data"
    
    init(apiClient: APIClient = .shared) {
        self.apiClient = apiClient
    }
    
    func login(request: LoginRequest) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(request)
        let response: AuthResponse = try await apiClient.request(endpoint: "auth/login", method: "POST", body: body)
        saveAuthData(response: response)
        return response
    }
    
    func register(request: RegisterRequest) async throws -> AuthResponse {
        let body = try JSONEncoder().encode(request)
        let response: AuthResponse = try await apiClient.request(endpoint: "auth/register", method: "POST", body: body)
        saveAuthData(response: response)
        return response
    }
    
    func logout() async {
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.removeObject(forKey: usernameKey)
        userDefaults.removeObject(forKey: userDataKey)
    }
    
    func getUsername() -> String? {
        userDefaults.string(forKey: usernameKey)
    }
    
    func getAccessToken() -> String? {
        userDefaults.string(forKey: tokenKey)
    }
    
    func isLoggedIn() -> Bool {
        getAccessToken() != nil
    }
    
    private func saveAuthData(response: AuthResponse) {
        if let token = response.token {
            userDefaults.set(token, forKey: tokenKey)
        }
        userDefaults.set(response.name, forKey: usernameKey)
        
        if let data = try? JSONEncoder().encode(response) {
            userDefaults.set(data, forKey: userDataKey)
        }
    }
}
