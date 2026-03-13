import Foundation
import Combine

class LocationManager: ObservableObject {
    @Published var selectedLocation: LocationSearchResult?
    
    static let shared = LocationManager()
    
    private init() {}
}
