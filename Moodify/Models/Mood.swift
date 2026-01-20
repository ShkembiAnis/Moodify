//
//  Mood.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation

enum Mood: String, CaseIterable, Identifiable {
    case happy = "Happy"
    case sad = "Sad"
    case energetic = "Energetic"
    case chill = "Chill"
    case romantic = "Romantic"
    case focused = "Focused"
    
    var id: String { self.rawValue }
    
    var searchTerm: String {
        switch self {
        case .happy:
            return "pop"
        case .sad:
            return "blues"
        case .energetic:
            return "rock"
        case .chill:
            return "ambient"
        case .romantic:
            return "romance"
        case .focused:
            return "classical"
        }
    }
    
    var emoji: String {
        switch self {
        case .happy:
            return "😊"
        case .sad:
            return "😢"
        case .energetic:
            return "⚡"
        case .chill:
            return "😌"
        case .romantic:
            return "❤️"
        case .focused:
            return "🎯"
        }
    }
}
