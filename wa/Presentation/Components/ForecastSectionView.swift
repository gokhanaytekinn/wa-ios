import SwiftUI

struct ForecastSectionView: View {
    let forecasts: [SimpleForecast]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("5 Günlük Tahmin")
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
                    Text("%\(forecast.precipitationChance)")
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
        // Simple day extraction for demo, real implementation would use DateFormatter
        let days = ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"]
        // Assuming dateString is "yyyy-MM-dd"
        return dateString // Placeholder
    }
}
