//
//  SearchView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var playerViewModel = PlayerViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Mood Selection Section
                MoodSelectionView(selectedMood: $viewModel.selectedMood) { mood in
                    Task {
                        await viewModel.searchByMood(mood)
                    }
                }
                .padding()
                
                Divider()
                
                // Results Section
                if viewModel.isLoading {
                    Spacer()
                    ProgressView(Constants.Messages.loading)
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        Image(systemName: Constants.Icons.error)
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    Spacer()
                } else if viewModel.tracks.isEmpty {
                    Spacer()
                    VStack(spacing: Constants.UI.mediumSpacing) {
                        Image(systemName: Constants.Icons.music)
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(Constants.Messages.selectMood)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    // Track List
                    List(viewModel.tracks) { track in
                        NavigationLink(destination: TrackDetailView(track: track)) {
                            TrackRowView(track: track, isPlaying: playerViewModel.isTrackPlaying(track))
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Discover")
            .toolbar {
                if !viewModel.tracks.isEmpty {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            viewModel.clearSearch()
                        }) {
                            Text("Clear")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
