//
//  PlayerViewModel.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class PlayerViewModel: ObservableObject {
    
    private let playerService = AudioPlayerService.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var currentTrack: Track?
    
    init() {
        // Subscribe to player service updates
        playerService.$isPlaying
            .assign(to: &$isPlaying)
        
        playerService.$currentTime
            .assign(to: &$currentTime)
        
        playerService.$duration
            .assign(to: &$duration)
        
        playerService.$currentTrack
            .assign(to: &$currentTrack)
    }
    
    // Play a track
    func play(track: Track) {
        playerService.play(track: track)
    }
    
    // Pause playback
    func pause() {
        playerService.pause()
    }
    
    // Resume playback
    func resume() {
        playerService.resume()
    }
    
    // Stop playback
    func stop() {
        playerService.stop()
    }
    
    // Toggle play/pause
    func togglePlayPause() {
        playerService.togglePlayPause()
    }
    
    // Seek to position
    func seek(to time: Double) {
        playerService.seek(to: time)
    }
    
    // Check if a specific track is currently playing
    func isTrackPlaying(_ track: Track) -> Bool {
        return currentTrack?.trackId == track.trackId && isPlaying
    }
    
    // Formatted current time
    var currentTimeFormatted: String {
        formatTime(currentTime)
    }
    
    // Formatted duration
    var durationFormatted: String {
        formatTime(duration)
    }
    
    // Format time in mm:ss
    private func formatTime(_ time: Double) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    // Progress percentage (0-1)
    var progress: Double {
        guard duration > 0 else { return 0 }
        return currentTime / duration
    }
}
