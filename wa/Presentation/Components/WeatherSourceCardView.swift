import SwiftUI

struct WeatherSourceCardView: View {
    let source: WeatherSource
    let isExpanded: Bool
    let onToggle: () -> Void
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(source.source ?? localizer.string(.source))
                            .font(.headline)
                        Text(source.description ?? localizer.string(.errorLoading))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if let temp = source.temperature {
                            Text("\(Int(temp.rounded()))°")
                                .font(.title2)
                                .fontWeight(.bold)
                        } else {
                            Text("--°")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        
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
                        MetricRow(title: localizer.string(.temperature), value: source.temperature.map { "\(Int($0.rounded()))°" } ?? "--", icon: "thermometer.medium")
                        MetricRow(title: localizer.string(.feelsLike), value: source.feelsLike.map { "\(Int($0.rounded()))°" } ?? "--", icon: "thermometer.low")
                    }
                    
                    HStack(spacing: 16) {
                        MetricRow(title: localizer.string(.humidity), value: source.humidity.map { "\(localizer.string(.humidityUnit))\($0)" } ?? "--", icon: "humidity")
                        MetricRow(title: localizer.string(.wind), value: source.windSpeed.map { "\($0) \(localizer.string(.windUnit))" } ?? "--", icon: "wind")
                    }
                    
                    HStack(spacing: 16) {
                        MetricRow(title: localizer.string(.precipitation), value: source.precipitation.map { "\($0) mm" } ?? "--", icon: "cloud.rain")
                        Spacer().frame(maxWidth: .infinity)
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
