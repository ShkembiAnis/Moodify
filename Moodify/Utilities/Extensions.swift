//
//  Extensions.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import SwiftUI

// MARK: - Color Extensions
extension Color {
    static let primaryAccent = Color.blue
    static let secondaryAccent = Color.purple
    
    // Mood colors
    static func moodColor(for mood: Mood) -> Color {
        switch mood {
        case .happy:
            return .yellow
        case .sad:
            return .blue
        case .energetic:
            return .red
        case .chill:
            return .green
        case .romantic:
            return .pink
        case .focused:
            return .purple
        }
    }
}

// MARK: - View Extensions
extension View {
    // Custom card style
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .cornerRadius(Constants.UI.mediumCornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // Custom button style
    func customButtonStyle(backgroundColor: Color = .blue) -> some View {
        self
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(Constants.UI.smallCornerRadius)
    }
}

// MARK: - String Extensions
extension String {
    // Truncate string to specific length
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }
}

// MARK: - Double Extensions
extension Double {
    // Format as time string (mm:ss)
    var timeString: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

// MARK: - Date Extensions
extension Date {
    // Format as relative time (e.g., "2 days ago")
    var relativeTime: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    // Format as short date (e.g., "Jan 20, 2026")
    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

// MARK: - Array Extensions
extension Array where Element == Track {
    // Remove duplicates based on trackId
    func removingDuplicates() -> [Track] {
        var seen = Set<Int>()
        return self.filter { track in
            guard !seen.contains(track.trackId) else { return false }
            seen.insert(track.trackId)
            return true
        }
    }
}

// MARK: - Optional Extensions
extension Optional where Wrapped == String {
    // Provide default value for optional strings
    var orEmpty: String {
        return self ?? ""
    }
    
    var orUnknown: String {
        return self ?? "Unknown"
    }
}

// MARK: - Binding Extensions
extension Binding {
    // Create a binding with a default value
    func withDefault<T>(_ defaultValue: T) -> Binding<T> where Value == Optional<T> {
        return Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }
}
