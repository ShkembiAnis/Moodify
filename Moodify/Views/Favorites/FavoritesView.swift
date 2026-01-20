//
//  FavoritesView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FavoriteTrack.addedDate, order: .reverse) private var favorites: [FavoriteTrack]
    
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var showingDeleteAlert = false
    @State private var selectedCategory: FavoriteCategory = .all
    
    // Available categories based on favorites
    private var availableCategories: [FavoriteCategory] {
        var categories: [FavoriteCategory] = [.all, .recent]
        
        // Get unique genres from favorites
        let genres = Set(favorites.compactMap { $0.primaryGenreName })
        let genreCategories = genres.sorted().map { FavoriteCategory.genre($0) }
        
        categories.append(contentsOf: genreCategories)
        return categories
    }
    
    // Filtered favorites based on selected category
    private var filteredFavorites: [FavoriteTrack] {
        switch selectedCategory {
        case .all:
            return favorites
        case .recent:
            // Last 7 days
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            return favorites.filter { $0.addedDate >= sevenDaysAgo }
        case .genre(let genreName):
            return favorites.filter { $0.primaryGenreName == genreName }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Category Picker (only show if there are favorites)
                if !favorites.isEmpty {
                    CategoryPickerView(
                        categories: availableCategories,
                        selectedCategory: $selectedCategory
                    )
                    .padding(.horizontal)
                    .padding(.vertical, Constants.UI.smallSpacing)
                    
                    Divider()
                }
                
                // Content
                Group {
                    if favorites.isEmpty {
                        // Empty State
                        VStack(spacing: Constants.UI.largeSpacing) {
                            Spacer()
                            
                            Image(systemName: Constants.Icons.heart)
                                .font(.system(size: 70))
                                .foregroundColor(.gray)
                            
                            Text(Constants.Messages.noFavorites)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(Constants.Messages.noFavoritesDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, Constants.UI.largeSpacing)
                            
                            Spacer()
                        }
                    } else if filteredFavorites.isEmpty {
                        // No results in selected category
                        VStack(spacing: Constants.UI.largeSpacing) {
                            Spacer()
                            
                            Image(systemName: "line.3.horizontal.decrease.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No tracks in \(selectedCategory.displayName)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    } else {
                        // Favorites List
                        List {
                            // Section header with count
                            Section {
                                ForEach(filteredFavorites) { favorite in
                                    NavigationLink(destination: TrackDetailView(track: favorite.toTrack())) {
                                        FavoriteTrackRowView(
                                            favorite: favorite,
                                            isPlaying: playerViewModel.isTrackPlaying(favorite.toTrack())
                                        )
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button(role: .destructive) {
                                            deleteFavorite(favorite)
                                        } label: {
                                            Label("Delete", systemImage: Constants.Icons.delete)
                                        }
                                    }
                                }
                            } header: {
                                HStack {
                                    Text(selectedCategory.displayName)
                                    Spacer()
                                    Text("\(filteredFavorites.count) track\(filteredFavorites.count == 1 ? "" : "s")")
                                }
                                .font(.subheadline)
                                .textCase(nil)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                if !favorites.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(role: .destructive, action: {
                                showingDeleteAlert = true
                            }) {
                                Label("Clear All", systemImage: Constants.Icons.delete)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .alert("Clear All Favorites?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear All", role: .destructive) {
                    clearAllFavorites()
                }
            } message: {
                Text("This will remove all \(favorites.count) favorite tracks. This action cannot be undone.")
            }
        }
    }
    
    // Delete a single favorite
    private func deleteFavorite(_ favorite: FavoriteTrack) {
        withAnimation {
            modelContext.delete(favorite)
            try? modelContext.save()
            
            // If category becomes empty after deletion, switch to "All"
            if filteredFavorites.count == 1 && selectedCategory != .all {
                selectedCategory = .all
            }
        }
    }
    
    // Clear all favorites
    private func clearAllFavorites() {
        withAnimation {
            favorites.forEach { favorite in
                modelContext.delete(favorite)
            }
            try? modelContext.save()
            selectedCategory = .all
        }
    }
}

// MARK: - Favorite Category
enum FavoriteCategory: Hashable {
    case all
    case recent
    case genre(String)
    
    var displayName: String {
        switch self {
        case .all:
            return "All Tracks"
        case .recent:
            return "Recent"
        case .genre(let name):
            return name
        }
    }
    
    var icon: String {
        switch self {
        case .all:
            return "music.note.list"
        case .recent:
            return "clock"
        case .genre:
            return "music.note"
        }
    }
}

// MARK: - Category Picker View
struct CategoryPickerView: View {
    let categories: [FavoriteCategory]
    @Binding var selectedCategory: FavoriteCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.UI.smallSpacing) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        withAnimation {
                            selectedCategory = category
                        }
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: FavoriteCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.caption)
                
                Text(category.displayName)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ?
                Color.blue :
                Color(.systemGray6)
            )
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Favorite Track Row View
struct FavoriteTrackRowView: View {
    let favorite: FavoriteTrack
    let isPlaying: Bool
    
    var body: some View {
        HStack(spacing: Constants.UI.mediumSpacing) {
            // Album Artwork
            AsyncImage(url: URL(string: favorite.artworkUrl100 ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: Constants.UI.thumbnailSize, height: Constants.UI.thumbnailSize)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: Constants.Icons.music)
                        .foregroundColor(.gray)
                        .frame(width: Constants.UI.thumbnailSize, height: Constants.UI.thumbnailSize)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: Constants.UI.thumbnailSize, height: Constants.UI.thumbnailSize)
            .cornerRadius(Constants.UI.smallCornerRadius)
            
            // Track Info
            VStack(alignment: .leading, spacing: 4) {
                Text(favorite.trackName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(favorite.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                HStack(spacing: Constants.UI.smallSpacing) {
                    if let genre = favorite.primaryGenreName {
                        Text(genre)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(favorite.addedDate.relativeTime)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Playing Indicator & Favorite Icon
            HStack(spacing: Constants.UI.smallSpacing) {
                if isPlaying {
                    Image(systemName: "waveform")
                        .foregroundColor(.blue)
                        .symbolEffect(.pulse)
                }
                
                Image(systemName: Constants.Icons.heartFill)
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("With Favorites") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: FavoriteTrack.self, configurations: config)
    
    // Add sample favorites with different genres
    let favorite1 = FavoriteTrack(
        trackId: 1,
        trackName: "Pop Song",
        artistName: "Pop Artist",
        collectionName: "Pop Album",
        artworkUrl100: nil,
        previewUrl: nil,
        trackTimeMillis: 180000,
        releaseDate: nil,
        primaryGenreName: "Pop"
    )
    
    let favorite2 = FavoriteTrack(
        trackId: 2,
        trackName: "Rock Song",
        artistName: "Rock Artist",
        collectionName: "Rock Album",
        artworkUrl100: nil,
        previewUrl: nil,
        trackTimeMillis: 200000,
        releaseDate: nil,
        primaryGenreName: "Rock"
    )
    
    let favorite3 = FavoriteTrack(
        trackId: 3,
        trackName: "Jazz Song",
        artistName: "Jazz Artist",
        collectionName: "Jazz Album",
        artworkUrl100: nil,
        previewUrl: nil,
        trackTimeMillis: 220000,
        releaseDate: nil,
        primaryGenreName: "Jazz"
    )
    
    container.mainContext.insert(favorite1)
    container.mainContext.insert(favorite2)
    container.mainContext.insert(favorite3)
    
    return FavoritesView()
        .modelContainer(container)
}

#Preview("Empty State") {
    FavoritesView()
        .modelContainer(for: FavoriteTrack.self, inMemory: true)
}
