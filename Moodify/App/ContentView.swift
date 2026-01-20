//
//  ContentView.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Tab 1: Search
            SearchView()
                .tabItem {
                    Label("Search", systemImage: Constants.Icons.search)
                }
            
            // Tab 2: Favorites
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: Constants.Icons.favorites)
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FavoriteTrack.self, inMemory: true)
}
