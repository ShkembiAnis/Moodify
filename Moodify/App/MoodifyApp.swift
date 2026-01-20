//
//  MoodifyApp.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI
import SwiftData

@main
struct MoodifyApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteTrack.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
