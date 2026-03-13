import SwiftUI

struct WeatherSourceCardView: View {
    let source: WeatherSource
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(source.sourceName)
                            .font(.headline)
                        Text(source.current.condition)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        Text("\(Int(source.current.temperature.rounded()))°")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Divider()
                    .padding(.horizontal)
                
                VStack(spacing: 12) {
                    HStack(spacing: 16) {
                        MetricRow(title: "Hissedilen", value: "\(Int(source.current.feelsLike.rounded()))°", icon: "thermometer")
                        MetricRow(title: "Nem", value: "%\(source.current.humidity)", icon: "humidity")
                    }
                    
                    HStack(spacing: 16) {
                        MetricRow(title: "Rüzgar", value: "\(source.current.windSpeed) km/s", icon: "wind")
                        MetricRow(title: "Basınç", value: "\(source.current.pressure) hPa", icon: "barometer")
                    }
                }
                .padding()
            }
        }
        .weatherCardStyle()
        .padding(.horizontal, 4)
    }
}

// Internal helper
private struct MetricRow: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}
