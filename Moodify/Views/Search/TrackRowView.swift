//
//  TrackRowView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI

struct TrackRowView: View {
    let track: Track
    let isPlaying: Bool
    
    var body: some View {
        HStack(spacing: Constants.UI.mediumSpacing) {
            // Album Artwork
            AsyncImage(url: URL(string: track.artworkUrl100 ?? "")) { phase in
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
                Text(track.trackName)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(track.artistName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if let album = track.collectionName {
                    Text(album)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            // Playing Indicator
            if isPlaying {
                Image(systemName: "waveform")
                    .foregroundColor(.blue)
                    .symbolEffect(.pulse)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    List {
        TrackRowView(
            track: Track(
                trackId: 1,
                trackName: "Sample Song",
                artistName: "Sample Artist",
                collectionName: "Sample Album",
                artworkUrl100: nil,
                previewUrl: nil,
                trackTimeMillis: 180000,
                releaseDate: nil,
                primaryGenreName: "Pop"
            ),
            isPlaying: false
        )
        
        TrackRowView(
            track: Track(
                trackId: 2,
                trackName: "Playing Song",
                artistName: "Another Artist",
                collectionName: "Another Album",
                artworkUrl100: nil,
                previewUrl: nil,
                trackTimeMillis: 200000,
                releaseDate: nil,
                primaryGenreName: "Rock"
            ),
            isPlaying: true
        )
    }
}
