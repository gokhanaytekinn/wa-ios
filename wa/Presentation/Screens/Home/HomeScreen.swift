import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var localizer: Localizer
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient or Image
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppTheme.spacing) {
                        // Search Bar
                        searchBar
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if let weather = viewModel.weather {
                            weatherContent(weather)
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "cloud.sun.fill")
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
                
                // Search Results Overlay
                if !viewModel.searchResults.isEmpty {
                    searchResultsOverlay
                }
            }
            .navigationTitle("Kokyel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.toggleFavorite() }) {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .primary)
                    }
                }
            }
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
    private func weatherContent(_ weather: WeatherData) -> some View {
        VStack(spacing: AppTheme.spacing) {
            // Main Weather Info
            VStack(spacing: 4) {
                Text(weather.city ?? "")
                    .font(.title)
                    .fontWeight(.bold)
                
                if let temp = weather.temperature {
                    Text("\(Int(temp.rounded()))°")
                        .font(.system(size: 64))
                        .fontWeight(.thin)
                } else {
                    Text("--°")
                        .font(.system(size: 64))
                        .fontWeight(.thin)
                }
                
                Text(weather.description ?? "Bilinmiyor")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 20)
            
            // Metrics Card (Single container)
            VStack(spacing: 16) {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    WeatherMetricCard(title: localizer.string(.humidity), value: weather.humidity.map { "\(localizer.string(.humidityUnit))\($0)" } ?? "--", icon: "humidity", unit: "")
                    WeatherMetricCard(title: localizer.string(.wind), value: weather.windSpeed.map { "\($0)" } ?? "--", icon: "wind", unit: localizer.string(.windUnit))
                    WeatherMetricCard(title: localizer.string(.feelsLike), value: weather.feelsLike.map { "\(Int($0.rounded()))°" } ?? "--", icon: "thermometer", unit: "")
                    WeatherMetricCard(title: localizer.string(.precipitation), value: weather.precipitation.map { "\($0) mm" } ?? "--", icon: "cloud.rain", unit: "")
                }
                
                Divider()
                
                HStack {
                    Text(localizer.string(.source))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(weather.source ?? "--")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .weatherCardStyle()
            
            // Forecast removed from here as per user request
            
            // Other Sources Section
            VStack(alignment: .leading, spacing: 12) {
                Text(localizer.string(.sourceTitle))
                    .font(.headline)
                    .padding(.horizontal, 4)
                
                VStack(spacing: 8) {
                    ForEach(weather.sources ?? []) { source in
                        WeatherSourceCardView(
                            source: source,
                            isExpanded: viewModel.expandedSources.contains(source.id),
                            onToggle: { viewModel.toggleSource(source.id) }
                        )
                    }
                }
            }
            .padding(.top, 8)
        }
    }
}
