import SwiftUI

struct FavoritesScreen: View {
    @StateObject var viewModel: FavoritesViewModel
    @EnvironmentObject var localizer: Localizer
    let onSelectLocation: (LocationSearchResult) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.Colors.background.ignoresSafeArea()
                
                if viewModel.isLoading && viewModel.favorites.isEmpty {
                    ProgressView()
                } else if viewModel.favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 64))
                            .foregroundColor(.secondary)
                        Text(localizer.string(.noFavorites))
                            .foregroundColor(.secondary)
                    }
                } else {
                    List {
                        ForEach(viewModel.favorites) { location in
                            FavoriteRow(location: location) {
                                onSelectLocation(location)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    Task { await viewModel.removeFavorite(location: location) }
                                } label: {
                                    Label(localizer.string(.delete), systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(localizer.string(.favorites))
            .onAppear {
                Task { await viewModel.loadFavorites() }
            }
        }
    }
}

struct FavoriteRow: View {
    let location: LocationSearchResult
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(.blue)
                Text(location.getDisplayName())
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
    }
}
