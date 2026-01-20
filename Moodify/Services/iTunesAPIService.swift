//
//  iTunesAPIService.swift
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

//
//  iTunesAPIService.swift
//  Moodify
//
//  Created on 2026
//

import Foundation

class iTunesAPIService {
    
    static let shared = iTunesAPIService()
    
    private init() {}
    
    private let baseURL = Constants.API.baseURL
    
    // Search tracks by mood
    func searchTracks(for mood: Mood) async throws -> [Track] {
        let searchTerm = mood.searchTerm
        return try await searchTracks(term: searchTerm)
    }
    
    // Generic search by term
    func searchTracks(term: String, limit: Int = Constants.API.defaultLimit) async throws -> [Track] {  // ✅ Use constant
        // Build URL with query parameters
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = components?.url else {
            throw APIError.invalidURL
        }
        
        // Make the request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Check response status
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        // Decode the response
        do {
            let decoder = JSONDecoder()
            let iTunesResponse = try decoder.decode(iTunesResponse.self, from: data)
            return iTunesResponse.results
        } catch {
            throw APIError.decodingError(error)
        }
    }
    
    // Search by artist name
    func searchByArtist(_ artistName: String, limit: Int = Constants.API.defaultLimit) async throws -> [Track] {  // ✅ Use constant
        return try await searchTracks(term: artistName, limit: limit)
    }
}

// MARK: - API Errors
enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
