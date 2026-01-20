//
//  Track.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation

// Response wrapper from iTunes API
struct iTunesResponse: Codable {
    let resultCount: Int
    let results: [Track]
}

// Main Track model from iTunes API
struct Track: Codable, Identifiable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let artworkUrl100: String?
    let previewUrl: String?
    let trackTimeMillis: Int?
    let releaseDate: String?
    let primaryGenreName: String?
    
    var id: Int { trackId }
    
    // Computed property for larger artwork
    var artworkUrl600: String? {
        artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
    }
    
    // Formatted track duration
    var durationFormatted: String {
        guard let millis = trackTimeMillis else { return "Unknown" }
        let seconds = millis / 1000
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    // Formatted release year
    var releaseYear: String? {
        guard let dateString = releaseDate else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        if let date = dateFormatter.date(from: dateString) {
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            return yearFormatter.string(from: date)
        }
        return nil
    }
}
