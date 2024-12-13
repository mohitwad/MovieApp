//
//  MovieModel.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
struct MovieModel:Codable {
    var page,totalPages,totalResults,statusCode: Int?
    var results:[MovieResults]?
    var success:Bool?
    var statusMessage: String?
    
    private enum CodingKeys : String, CodingKey {
        case page,results,success
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
struct MovieResults: Codable,Equatable {
    var adult,video: Bool?
    var backdropPath,originalLanguage,originalTitle,overview,posterPath,releaseDate,title: String?
    var id: Int?
    var popularity,voteAverage,voteCount: Double?
    var genreIds: [Int]?
    
    private enum CodingKeys : String, CodingKey {
        case adult,video,id,title,overview,popularity
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case genreIds = "genre_ids"
    }
}
