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
                        Text(source.sourceName ?? localizer.string(.source))
                            .font(.headline)
                        Text(source.current?.condition ?? localizer.string(.errorLoading))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        if let temp = source.current?.temperature {
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
                
                if let current = source.current {
                    VStack(spacing: 12) {
                        HStack(spacing: 16) {
                            MetricRow(title: localizer.string(.feelsLike), value: current.feelsLike.map { "\(Int($0.rounded()))°" } ?? "--", icon: "thermometer")
                            MetricRow(title: localizer.string(.humidity), value: current.humidity.map { "\(localizer.string(.humidityUnit))\($0)" } ?? "--", icon: "humidity")
                        }
                        
                        HStack(spacing: 16) {
                            MetricRow(title: localizer.string(.wind), value: current.windSpeed.map { "\($0) \(localizer.string(.windUnit))" } ?? "--", icon: "wind")
                            MetricRow(title: localizer.string(.precipitation), value: current.precipitation.map { "\($0) mm" } ?? "--", icon: "cloud.rain")
                        }
                    }
                    .padding()
                } else {
                    Text(localizer.string(.errorLoading))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding()
                }
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
