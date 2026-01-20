//
//  PlayerControlView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI

struct PlayerControlsView: View {
    let track: Track
    @ObservedObject var playerViewModel: PlayerViewModel
    
    var body: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            // Progress Bar
            VStack(spacing: Constants.UI.smallSpacing) {
                Slider(
                    value: Binding(
                        get: { playerViewModel.currentTime },
                        set: { newValue in
                            playerViewModel.seek(to: newValue)
                        }
                    ),
                    in: 0...max(playerViewModel.duration, 1)
                )
                .tint(.blue)
                
                HStack {
                    Text(playerViewModel.currentTimeFormatted)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(playerViewModel.durationFormatted)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Play/Pause Button
            HStack(spacing: Constants.UI.largeSpacing) {
                Spacer()
                
                Button(action: {
                    if playerViewModel.isPlaying && playerViewModel.currentTrack?.trackId == track.trackId {
                        playerViewModel.pause()
                    } else {
                        playerViewModel.play(track: track)
                    }
                }) {
                    Image(systemName: playerViewModel.isPlaying && playerViewModel.currentTrack?.trackId == track.trackId ? Constants.Icons.pause : Constants.Icons.play)
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(Constants.UI.mediumCornerRadius)
    }
}

#Preview {
    PlayerControlsView(
        track: Track(
            trackId: 1,
            trackName: "Sample Song",
            artistName: "Sample Artist",
            collectionName: "Sample Album",
            artworkUrl100: nil,
            previewUrl: "https://example.com/preview.m4a",
            trackTimeMillis: 180000,
            releaseDate: nil,
            primaryGenreName: "Pop"
        ),
        playerViewModel: PlayerViewModel()
    )
    .padding()
}
