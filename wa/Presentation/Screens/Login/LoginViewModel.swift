import Foundation
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isLoginMode = true
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var loginSuccess = false
    
    private let loginUseCase: LoginUseCase
    private let registerUseCase: RegisterUseCase
    
    init(loginUseCase: LoginUseCase, registerUseCase: RegisterUseCase) {
        self.loginUseCase = loginUseCase
        self.registerUseCase = registerUseCase
    }
    
    func handleSubmit() async {
        isLoading = true
        errorMessage = nil
        
        do {
            if isLoginMode {
                _ = try await loginUseCase.execute(request: LoginRequest(username: username, password: password))
            } else {
                _ = try await registerUseCase.execute(request: RegisterRequest(username: username, email: email, password: password))
            }
            loginSuccess = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
