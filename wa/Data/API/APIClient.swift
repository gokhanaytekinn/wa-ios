import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case unauthorized
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "https://wa.nxsapps.com/api/"
    
    private init() {}
    
    func request<T: Decodable>(endpoint: String, method: String = "GET", body: Data? = nil, queryParams: [String: String]? = nil) async throws -> T {
        var urlString = baseURL + endpoint
        
        if let queryParams = queryParams, !queryParams.isEmpty {
            var components = URLComponents(string: urlString)
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            if let finalURL = components?.url?.absoluteString {
                urlString = finalURL
            }
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Add auth token if available
        if let token = UserDefaults.standard.string(forKey: "access_token") {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError("Geçersiz sunucu yanıtı")
        }
        
        if httpResponse.statusCode == 401 {
            throw NetworkError.unauthorized
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            // Try to parse error message
            if let errorResponse = try? JSONDecoder().decode(ApiErrorResponse.self, from: data) {
                throw NetworkError.serverError(errorResponse.error?.message ?? "Bilinmeyen sunucu hatası")
            }
            throw NetworkError.serverError("Sunucu hatası: \(httpResponse.statusCode)")
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
}

// Minimal error response model to catch server messages
struct ApiErrorResponse: Codable {
    let error: ApiErrorInfo?
}

struct ApiErrorInfo: Codable {
    let message: String?
}
