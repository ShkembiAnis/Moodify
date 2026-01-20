//
//  FavouriteTrack.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import SwiftData

@Model
final class FavoriteTrack {
    var trackId: Int
    var trackName: String
    var artistName: String
    var collectionName: String?
    var artworkUrl100: String?
    var previewUrl: String?
    var trackTimeMillis: Int?
    var releaseDate: String?
    var primaryGenreName: String?
    var addedDate: Date
    
    init(trackId: Int,
         trackName: String,
         artistName: String,
         collectionName: String? = nil,
         artworkUrl100: String? = nil,
         previewUrl: String? = nil,
         trackTimeMillis: Int? = nil,
         releaseDate: String? = nil,
         primaryGenreName: String? = nil) {
        self.trackId = trackId
        self.trackName = trackName
        self.artistName = artistName
        self.collectionName = collectionName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.trackTimeMillis = trackTimeMillis
        self.releaseDate = releaseDate
        self.primaryGenreName = primaryGenreName
        self.addedDate = Date()
    }
    
    // Convenience initializer to create from Track model
    convenience init(from track: Track) {
        self.init(
            trackId: track.trackId,
            trackName: track.trackName,
            artistName: track.artistName,
            collectionName: track.collectionName,
            artworkUrl100: track.artworkUrl100,
            previewUrl: track.previewUrl,
            trackTimeMillis: track.trackTimeMillis,
            releaseDate: track.releaseDate,
            primaryGenreName: track.primaryGenreName
        )
    }
    
    // Convert to Track model for reusability
    func toTrack() -> Track {
        return Track(
            trackId: trackId,
            trackName: trackName,
            artistName: artistName,
            collectionName: collectionName,
            artworkUrl100: artworkUrl100,
            previewUrl: previewUrl,
            trackTimeMillis: trackTimeMillis,
            releaseDate: releaseDate,
            primaryGenreName: primaryGenreName
        )
    }
    
    // Computed property for larger artwork
    var artworkUrl600: String? {
        artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
    }
}
