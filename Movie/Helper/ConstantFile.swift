//
//  ConstantFile.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
enum MovieActionMessage: String {
    case success = "Movie saved successfully!"
    case failure = "Failed to save the movie. Please try again."
    case deletion = "Movie removed successfully."
}
struct AppConstants {
    struct API {
        static let apiToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxMDljYWY0MjM4YmY5MzU0OTEzYmRkZDQ0YmU1ZjY0OSIsIm5iZiI6MTczMzk3OTI2Ny4xMTAwMDAxLCJzdWIiOiI2NzVhNmM4M2Y1YjU2N2YzMTEzMGU5N2YiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.eeOxtQD6kR_DVc6nvE3tLEFQRwLBrneIM_t04aLozzo"
        static let imageBaseURL = "https://image.tmdb.org/t/p/original"
    }
}

struct EmptyMessage {
    
    struct Search {
        static let text = "You haven't searched yet, or no movies found for your current search term. Try a different one!"
        static let attribute = ""
        static let emptyQuery = "Search query cannot be empty."
        static let shortQuery = "Search query must be at least 3 characters long."
        static let invalidSearchQuery = "Search query contains invalid characters."
    }
    struct Saved {
        static let text = "You don't have any movies saved. Please browse our collection to add some to your list!"
        static let attribute = ""
    }
    struct NoInternet {
        static let text = "You are not connected to the internet. Please check your connection and Retry"
        static let attribute = "Retry"
    }
    
}
