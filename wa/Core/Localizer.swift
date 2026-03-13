import SwiftUI
import Combine

class Localizer: ObservableObject {
    private var cancellable: AnyCancellable?
    
    static let shared = Localizer()
    
    var language: AppLanguage {
        let val = UserDefaults.standard.string(forKey: "appLanguage") ?? "tr"
        return AppLanguage(rawValue: val) ?? .turkish
    }
    
    private init() {
        cancellable = NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
    
    func string(_ key: LocalizationKey) -> String {
        switch language {
        case .turkish: return key.tr
        case .english: return key.en
        }
    }
}

enum LocalizationKey {
    case weather, favorites, settings, forecast, searchPlaceholder, humidity, wind, feelsLike, source, temperature
    case pleaseSearch, errorLoading, high, low, precipitation, pressure, visibility, sourceTitle
    case theme, tempUnit, language, version, privacy, terms, fiveDayForecast, averageWeather, allSources
    case dailyForecast, windUnit, humidityUnit, noFavorites, delete
    
    var tr: String {
        switch self {
        case .weather: return "Hava Durumu"
        case .favorites: return "Favoriler"
        case .settings: return "Ayarlar"
        case .forecast: return "Tahmin"
        case .searchPlaceholder: return "Şehir veya ilçe ara..."
        case .humidity: return "Nem"
        case .wind: return "Rüzgar"
        case .feelsLike: return "Hissedilen"
        case .temperature: return "Sıcaklık"
        case .source: return "Kaynak"
        case .pleaseSearch: return "Lütfen bir konum arayın"
        case .errorLoading: return "Hava durumu yüklenemedi"
        case .high: return "Yüksek"
        case .low: return "Düşük"
        case .precipitation: return "Yağış"
        case .pressure: return "Basınç"
        case .visibility: return "Görüş"
        case .sourceTitle: return "Hava Durumu Kaynakları"
        case .theme: return "Tema"
        case .tempUnit: return "Sıcaklık Birimi"
        case .language: return "Uygulama Dili"
        case .version: return "Versiyon"
        case .privacy: return "Gizlilik Politikası"
        case .terms: return "Kullanım Koşulları"
        case .fiveDayForecast: return "5 Günlük Tahmin"
        case .averageWeather: return "Ortalama Hava Durumu"
        case .allSources: return "Tüm Kaynaklar"
        case .dailyForecast: return "Günlük Tahmin"
        case .windUnit: return "km/s"
        case .humidityUnit: return "%"
        case .noFavorites: return "Henüz favori konumunuz yok"
        case .delete: return "Sil"
        }
    }
    
    var en: String {
        switch self {
        case .weather: return "Weather"
        case .favorites: return "Favorites"
        case .settings: return "Settings"
        case .forecast: return "Forecast"
        case .searchPlaceholder: return "Search city or district..."
        case .humidity: return "Humidity"
        case .wind: return "Wind"
        case .feelsLike: return "Feels Like"
        case .temperature: return "Temperature"
        case .source: return "Source"
        case .pleaseSearch: return "Please search for a location"
        case .errorLoading: return "Weather could not be loaded"
        case .high: return "High"
        case .low: return "Low"
        case .precipitation: return "Precipitation"
        case .pressure: return "Pressure"
        case .visibility: return "Visibility"
        case .sourceTitle: return "Weather Sources"
        case .theme: return "Theme"
        case .tempUnit: return "Temp. Unit"
        case .language: return "App Language"
        case .version: return "Version"
        case .privacy: return "Privacy Policy"
        case .terms: return "Terms of Use"
        case .fiveDayForecast: return "5-Day Forecast"
        case .averageWeather: return "Average Weather"
        case .allSources: return "All Sources"
        case .dailyForecast: return "Daily Forecast"
        case .windUnit: return "km/h"
        case .humidityUnit: return "%"
        case .noFavorites: return "You have no favorite locations yet"
        case .delete: return "Delete"
        }
    }
}
