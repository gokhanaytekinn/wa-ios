import SwiftUI

struct ForecastScreen: View {
    @StateObject var viewModel: ForecastViewModel
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing) {
                        searchBar
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if let data = viewModel.forecastData {
                            forecastContent(data)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 64))
                                    .foregroundColor(.blue.opacity(0.6))
                                Text(localizer.string(.pleaseSearch))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 100)
                        }
                    }
                    .padding()
                }
                
                if !viewModel.searchResults.isEmpty {
                    searchResultsOverlay
                }
            }
            .navigationTitle(localizer.string(.fiveDayForecast))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(localizer.string(.searchPlaceholder), text: $viewModel.searchQuery)
            if viewModel.isSearching {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private var searchResultsOverlay: some View {
        VStack {
            Spacer().frame(height: 60)
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(viewModel.searchResults) { result in
                        Button(action: { viewModel.selectLocation(result) }) {
                            HStack {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.blue)
                                VStack(alignment: .leading) {
                                    Text(result.getDisplayName())
                                        .foregroundColor(.primary)
                                    if let country = result.country {
                                        Text(country)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                                Spacer()
                            }
                            .padding()
                        }
                        Divider().padding(.horizontal)
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding()
            }
            Spacer()
        }
    }
    
    @ViewBuilder
    private func forecastContent(_ data: ForecastResponse) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(data.city)\(data.district != nil ? ", \(data.district!)" : "")")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(data.sources ?? []) { source in
                    ForecastSourceAccordion(
                        source: source,
                        isExpanded: viewModel.expandedSources.contains(source.source),
                        onToggle: { viewModel.toggleSource(source.source) }
                    )
                }
            }
        }
    }
}

struct ForecastSourceAccordion: View {
    let source: ForecastSource
    let isExpanded: Bool
    let onToggle: () -> Void
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: onToggle) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(source.source)
                            .font(.headline)
                        Text("\(source.forecasts.count) \(localizer.string(.dailyForecast))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Divider().padding(.horizontal)
                
                VStack(spacing: 12) {
                    ForEach(source.forecasts) { forecast in
                        AccordionForecastRow(forecast: forecast)
                    }
                }
                .padding()
            }
        }
        .weatherCardStyle()
    }
}

struct AccordionForecastRow: View {
    let forecast: SimpleForecast
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(formatDate(forecast.date))
                        .fontWeight(.medium)
                    Text(forecast.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 12) {
                    Text("\(Int(forecast.maxTemperature.rounded()))°")
                        .foregroundColor(.red)
                    Text("\(Int(forecast.minTemperature.rounded()))°")
                        .foregroundColor(.blue)
                }
                .fontWeight(.bold)
            }
            
            HStack {
                Label("\(forecast.windSpeed) \(localizer.string(.windUnit))", systemImage: "wind")
                Spacer()
                Label("\(forecast.humidity ?? 0)%", systemImage: "humidity")
                Spacer()
                Label("\(forecast.precipitationChance ?? 0)%", systemImage: "cloud.rain")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding(8)
        .background(Color.primary.opacity(0.05))
        .cornerRadius(8)
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
