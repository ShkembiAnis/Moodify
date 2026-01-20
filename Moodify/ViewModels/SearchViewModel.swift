//
//  SearchViewModel.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

import Foundation
import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var tracks: [Track] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedMood: Mood?
    @Published var searchText: String = ""
    
    private let apiService = iTunesAPIService.shared
    
    // Search by mood
    func searchByMood(_ mood: Mood) async {
        selectedMood = mood
        isLoading = true
        errorMessage = nil
        tracks = []
        
        do {
            let results = try await apiService.searchTracks(for: mood)
            tracks = results
            
            if results.isEmpty {
                errorMessage = "No tracks found for \(mood.rawValue) mood"
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Search error: \(error)")
        }
        
        isLoading = false
    }
    
    // Generic search by text
    func search(term: String) async {
        guard !term.isEmpty else {
            tracks = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        tracks = []
        
        do {
            let results = try await apiService.searchTracks(term: term)
            tracks = results
            
            if results.isEmpty {
                errorMessage = "No tracks found for '\(term)'"
            }
        } catch {
            errorMessage = error.localizedDescription
            print("Search error: \(error)")
        }
        
        isLoading = false
    }
    
    // Clear search results
    func clearSearch() {
        tracks = []
        selectedMood = nil
        searchText = ""
        errorMessage = nil
    }
}
