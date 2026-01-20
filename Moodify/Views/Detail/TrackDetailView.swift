//
//  TrackDetailView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI
import SwiftData

struct TrackDetailView: View {
    let track: Track
    
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [FavoriteTrack]
    
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var isFavorite = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: Constants.UI.largeSpacing) {
                // Album Artwork
                AsyncImage(url: URL(string: track.artworkUrl600 ?? track.artworkUrl100 ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: Constants.UI.largeArtworkSize, height: Constants.UI.largeArtworkSize)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: Constants.UI.largeArtworkSize, height: Constants.UI.largeArtworkSize)
                            .cornerRadius(Constants.UI.largeCornerRadius)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    case .failure:
                        Image(systemName: Constants.Icons.music)
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                            .frame(width: Constants.UI.largeArtworkSize, height: Constants.UI.largeArtworkSize)
                            .background(Color(.systemGray6))
                            .cornerRadius(Constants.UI.largeCornerRadius)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: Constants.UI.largeArtworkSize, height: Constants.UI.largeArtworkSize)
                
                // Track Info
                VStack(spacing: Constants.UI.smallSpacing) {
                    Text(track.trackName)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text(track.artistName)
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    if let album = track.collectionName {
                        Text(album)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: Constants.UI.mediumSpacing) {
                        if let genre = track.primaryGenreName {
                            Label(genre, systemImage: "music.note")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let year = track.releaseYear {
                            Label(year, systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Label(track.durationFormatted, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, Constants.UI.smallSpacing)
                }
                .padding(.horizontal)
                
                // Player Controls
                if track.previewUrl != nil {
                    PlayerControlsView(
                        track: track,
                        playerViewModel: playerViewModel
                    )
                    .padding(.horizontal)
                } else {
                    Text(Constants.Messages.noPreview)
                        .foregroundColor(.secondary)
                        .padding()
                }
                
                // Favorite Button
                Button(action: toggleFavorite) {
                    HStack {
                        Image(systemName: isFavorite ? Constants.Icons.heartFill : Constants.Icons.heart)
                        Text(isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFavorite ? Color.red : Color.blue)
                    .cornerRadius(Constants.UI.mediumCornerRadius)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, Constants.UI.largeSpacing)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkIfFavorite()
        }
        .onDisappear {
            playerViewModel.stop()
        }
    }
    
    // Check if track is in favorites
    private func checkIfFavorite() {
        isFavorite = favorites.contains { $0.trackId == track.trackId }
    }
    
    // Toggle favorite status
    private func toggleFavorite() {
        if isFavorite {
            // Remove from favorites
            if let favorite = favorites.first(where: { $0.trackId == track.trackId }) {
                modelContext.delete(favorite)
            }
        } else {
            // Add to favorites
            let favorite = FavoriteTrack(from: track)
            modelContext.insert(favorite)
        }
        
        // Save context
        try? modelContext.save()
        
        // Update state
        isFavorite.toggle()
    }
}

#Preview {
    NavigationStack {
        TrackDetailView(
            track: Track(
                trackId: 1,
                trackName: "Sample Song",
                artistName: "Sample Artist",
                collectionName: "Sample Album",
                artworkUrl100: nil,
                previewUrl: "https://example.com/preview.m4a",
                trackTimeMillis: 180000,
                releaseDate: "2024-01-01T00:00:00Z",
                primaryGenreName: "Pop"
            )
        )
    }
    .modelContainer(for: FavoriteTrack.self, inMemory: true)
}
