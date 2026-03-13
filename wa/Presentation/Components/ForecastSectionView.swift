import SwiftUI

struct ForecastSectionView: View {
    let forecasts: [SimpleForecast]
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(localizer.string(.fiveDayForecast))
                .font(.headline)
                .padding(.horizontal, 4)
            
            VStack(spacing: AppTheme.spacing) {
                ForEach(forecasts) { forecast in
                    ForecastItemRow(forecast: forecast)
                }
            }
        }
    }
}

struct ForecastItemRow: View {
    let forecast: SimpleForecast
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(formatDate(forecast.date))
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(forecast.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                        .foregroundColor(.blue)
                    Text(forecast.precipitationChance.map { "%\($0)" } ?? "--")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 8) {
                    Text("\(Int(forecast.maxTemperature))°")
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text("\(Int(forecast.minTemperature))°")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .weatherCardStyle()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        formatter.locale = Locale(identifier: localizer.language == .turkish ? "tr" : "en")
        formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: date)
    }
}
