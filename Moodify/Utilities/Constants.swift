//
//  Constants.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import SwiftUI

struct Constants {
    
    // MARK: - API
    struct API {
        static let baseURL = "https://itunes.apple.com/search"
        static let defaultLimit = 25
        static let maxLimit = 200
    }
    
    // MARK: - UI
    struct UI {
        // Spacing
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 24
        
        // Corner Radius
        static let smallCornerRadius: CGFloat = 8
        static let mediumCornerRadius: CGFloat = 12
        static let largeCornerRadius: CGFloat = 16
        
        // Image Sizes
        static let thumbnailSize: CGFloat = 60
        static let smallArtworkSize: CGFloat = 100
        static let mediumArtworkSize: CGFloat = 200
        static let largeArtworkSize: CGFloat = 300
        
        // Animation
        static let defaultAnimation: Animation = .easeInOut(duration: 0.3)
    }
    
    // MARK: - Audio
    struct Audio {
        static let previewDuration: Double = 30.0
        static let seekInterval: Double = 5.0
    }
    
    // MARK: - Messages
    struct Messages {
        static let noFavorites = "No favorites yet"
        static let noFavoritesDescription = "Add tracks to your favorites by tapping the heart icon"
        static let noResults = "No results found"
        static let selectMood = "Select a mood to discover music"
        static let loading = "Loading..."
        static let errorTitle = "Oops!"
        static let noPreview = "No preview available"
    }
    
    // MARK: - SF Symbols
    struct Icons {
        static let play = "play.fill"
        static let pause = "pause.fill"
        static let heart = "heart"
        static let heartFill = "heart.fill"
        static let music = "music.note"
        static let search = "magnifyingglass"
        static let favorites = "heart.circle.fill"
        static let delete = "trash"
        static let error = "exclamationmark.triangle"
    }
}
