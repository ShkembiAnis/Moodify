//
//  README.md
//  Moodify
//
//  Created by Anis Shkembi on 20.01.26.
//

# 🎵 Moodify

A mood-based music discovery iOS app that helps you find the perfect tracks based on how you're feeling. Built with SwiftUI, SwiftData, and the iTunes Search API.

## ✨ Features

### Core Functionality
- 🎭 **Mood-Based Search**: Select from 6 different moods (Happy, Sad, Energetic, Chill, Romantic, Focused)
- 🎵 **Music Discovery**: Browse tracks matched to your selected mood via iTunes API
- 🎧 **Audio Preview**: Listen to 30-second previews of tracks directly in the app
- ❤️ **Favorites**: Save your favorite tracks with SwiftData persistence
- 🏷️ **Smart Categorization**: Organize favorites by genre or view recent additions

### Technical Features
- ✅ SwiftUI-based modern iOS interface
- ✅ SwiftData for local data persistence
- ✅ RESTful API integration (iTunes Search API)
- ✅ AVFoundation audio playback
- ✅ MVVM architecture pattern
- ✅ Async/await for modern concurrency

## 📱 Screenshots

### Search & Discovery
- Select a mood and discover matching tracks
- Browse search results with album artwork
- Real-time loading states

### Track Details
- Large album artwork display
- Full track information (artist, album, genre, duration)
- Interactive audio player with progress bar
- Add/remove favorites

### Favorites Management
- View all saved tracks
- Filter by category (All, Recent, Genre)
- Swipe to delete individual tracks
- Clear all favorites option

## 🏗️ Architecture

### Project Structure
```
Moodify/
├── App/
│   ├── MoodifyApp.swift          # App entry point with SwiftData setup
│   └── ContentView.swift         # Root TabView
│
├── Models/
│   ├── Track.swift               # iTunes API response model
│   ├── FavoriteTrack.swift       # SwiftData persistence model
│   └── Mood.swift                # Mood enum with genre mapping
│
├── ViewModels/
│   ├── SearchViewModel.swift     # Search logic and state
│   └── PlayerViewModel.swift     # Audio player state
│
├── Views/
│   ├── Search/
│   │   ├── SearchView.swift
│   │   ├── MoodSelectionView.swift
│   │   └── TrackRowView.swift
│   ├── Detail/
│   │   ├── TrackDetailView.swift
│   │   └── PlayerControlsView.swift
│   └── Favorites/
│       └── FavoritesView.swift
│
├── Services/
│   ├── iTunesAPIService.swift    # API networking layer
│   └── AudioPlayerService.swift  # AVPlayer wrapper
│
└── Utilities/
    ├── Constants.swift           # App-wide constants
    └── Extensions.swift          # Helper extensions
```

### Design Patterns
- **MVVM (Model-View-ViewModel)**: Separation of concerns
- **Singleton**: Shared services (API, Audio Player)
- **Repository Pattern**: Data access abstraction
- **Observer Pattern**: Combine for reactive updates

## 🛠️ Technologies Used

- **Swift 5.9+**
- **SwiftUI**: Modern declarative UI framework
- **SwiftData**: Apple's new persistence framework
- **AVFoundation**: Audio playback (AVPlayer)
- **Combine**: Reactive programming
- **iTunes Search API**: Music data source

## 📋 Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## 🚀 Getting Started

### Installation

1. Clone the repository:
```bash
git clone https://github.com/ShkembiAnis/Moodify.git
cd Moodify
```

2. Open the project in Xcode:
```bash
open Moodify.xcodeproj
```

3. Build and run:
   - Select a simulator or physical device
   - Press `Cmd + R` to build and run

### No Additional Setup Required!
- No API keys needed (iTunes Search API is public)
- No CocoaPods or SPM dependencies
- SwiftData database creates automatically on first launch

## 🎯 Usage

1. **Discover Music**:
   - Launch the app
   - Tap on a mood that matches your current feeling
   - Browse the curated track list

2. **Preview Tracks**:
   - Tap on any track to view details
   - Press play to listen to a 30-second preview
   - Use the progress bar to seek through the preview

3. **Save Favorites**:
   - In the track detail view, tap "Add to Favorites"
   - Access your favorites from the Favorites tab
   - Organize by genre or view recent additions

4. **Manage Favorites**:
   - Swipe left to delete individual tracks
   - Use the menu to clear all favorites
   - Categories automatically update based on your library

## 🎨 Mood to Genre Mapping

| Mood | Genre/Search Term |
|------|-------------------|
| 😊 Happy | Pop |
| 😢 Sad | Blues |
| ⚡ Energetic | Rock |
| 😌 Chill | Ambient |
| ❤️ Romantic | Romance |
| 🎯 Focused | Classical |

## 🧪 Testing

The app includes SwiftUI previews for all major components:
```bash
# Open any View file in Xcode
# Press Option + Cmd + Enter to show preview canvas
```

## 📝 API Reference

### iTunes Search API
- **Base URL**: `https://itunes.apple.com/search`
- **Parameters**:
  - `term`: Search query
  - `media`: "music"
  - `entity`: "song"
  - `limit`: Number of results (default: 25)
- **Documentation**: [Apple iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/)

## 🤝 Contributing

This is a university project, but suggestions and feedback are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is created as part of a university iOS development course.

## 👨‍💻 Author

**Anis Shkembi**
- GitHub: [@ShkembiAnis](https://github.com/ShkembiAnis)

## 🙏 Acknowledgments

- iTunes Search API by Apple
- SwiftUI and SwiftData documentation
- iOS development community

## 📚 Project Context

This app was developed to fulfill the following requirements:
- ✅ Minimum 2 pages/views (Search, Detail, Favorites)
- ✅ REST API integration (iTunes Search API)
- ✅ Data persistence (SwiftData)
- ✅ Additional framework integration (AVFoundation for audio playback)

---

**Made with ❤️ and SwiftUI**
