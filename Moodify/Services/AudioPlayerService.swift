//
//  AudioPlayerService.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerService: ObservableObject {
    
    static let shared = AudioPlayerService()
    
    private var player: AVPlayer?
    private var timeObserver: Any?
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var currentTrack: Track?
    
    private init() {
        setupAudioSession()
    }
    
    // Setup audio session for playback
    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
    }
    
    // Play a track
    func play(track: Track) {
        guard let previewUrlString = track.previewUrl,
              let url = URL(string: previewUrlString) else {
            print("No preview URL available")
            return
        }
        
        // If same track, just resume
        if currentTrack?.trackId == track.trackId, let player = player {
            player.play()
            isPlaying = true
            return
        }
        
        // Stop current track
        stop()
        
        // Create new player
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        currentTrack = track
        
        // Observe playback time
        addTimeObserver()
        
        // Observe when track finishes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidFinishPlaying),
            name: .AVPlayerItemDidPlayToEndTime,
            object: playerItem
        )
        
        // Get duration
        Task { @MainActor in
            if let duration = try? await playerItem.asset.load(.duration) {
                self.duration = CMTimeGetSeconds(duration)
            }
        }
        
        player?.play()
        isPlaying = true
    }
    
    // Pause playback
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    // Resume playback
    func resume() {
        player?.play()
        isPlaying = true
    }
    
    // Stop playback
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        currentTime = 0
        duration = 0
        removeTimeObserver()
    }
    
    // Toggle play/pause
    func togglePlayPause() {
        if isPlaying {
            pause()
        } else {
            resume()
        }
    }
    
    // Seek to time
    func seek(to time: Double) {
        let cmTime = CMTime(seconds: time, preferredTimescale: 600)
        player?.seek(to: cmTime)
    }
    
    // Add time observer for progress updates
    private func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = CMTimeGetSeconds(time)
        }
    }
    
    // Remove time observer
    private func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    // Handle track finishing
    @objc private func playerDidFinishPlaying() {
        isPlaying = false
        currentTime = 0
    }
    
    deinit {
        removeTimeObserver()
        NotificationCenter.default.removeObserver(self)
    }
}
