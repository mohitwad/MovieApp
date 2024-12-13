# MovieApp
<img src="https://img.shields.io/badge/status-Active-green" height="20"> <img src="https://img.shields.io/github/issues/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/stars/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/license/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/badge/architecture-MVVM-yellow" height="20"> <img src="https://img.shields.io/badge/language-Swift-yellow" height="20"> 

The Movie Database (TMDb) iOS App in Swift - https://developers.themoviedb.org/3/getting-started/introduction

## Technical specs
- Language: Swift
- Networking: URLSession
- DB Store: CoreData
- Architecture: MVVM
- ViewModels and ViewData for storing UI state
- Swift standard coding/decoding for custom objects
- Testing: XCTest

## Features
- Search Movies: Search for movies using keywords and filter results by pages.
- Movie Details: View detailed information about a selected movie, including its title, description, and rating.
- Save Favorites: Save and manage a list of your favorite movies locally.
- Offline Access: Saved movies are accessible offline using local storage.
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) for image fetching and caching
- Search Tab - not implemented
- Custom Error handling View
- No internet Connection View with retry button

## Key Components:
 - Network Layer: Handles API requests and responses using Async/Await
 - ViewModel Layer: Manages business logic and prepares data for the view.
 - Storage Layer: Manages local data persistence using Core Data.

## Screenshots
|Now Playing|Saved Items|Movie Detail View|
|:-:|:-:|:-:|
|<img src="https://ibb.co/VjGTS71" width="250"/>|<img src="https://ibb.co/qD79LFD" width="250"/>|<img src="https://ibb.co/CMdYWpj" width="250"/>|<img src="https://ibb.co/3RW8k5X" width="250"/>

## Steps to build and run
- Clone repo (pod files are included)
- Open `Movie.xcworkspace` in XCode
  - Select Target Movie (pre-selected)
  - Choose simulator/device of choice
- Click on Run

## Requirements
- iOS 15.6 or later
- Xcode 16.0 or later (visionOS requires Xcode 16.1)

## Usage
- Searching for Movies
- Enter a keyword in the search bar.
- Browse the list of results.
- Viewing Movie Details
- Save/Unsave Movies
- Access your saved movies from the "Saved Movies" section.
- Unit Testing

## API Endpoints

- Search Movies: GET /search/movie

- Movie Details: GET /movie/{movie_id}


## License

- This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgments

- The Movie Database (TMDb) for providing movie data.




