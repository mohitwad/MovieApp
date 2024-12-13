//
//  MovieDetailModel.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
struct MovieDetailModel:Codable {
    var adult,video,success: Bool?
    var backdropPath,originalLanguage,originalTitle,overview,posterPath,releaseDate,title,statusMessage,homepage,imdbId,tagline,status: String?
    var id,statusCode,budget,revenue,runtime: Int?
    var popularity,voteAverage,voteCount: Double?
    var belongsToCollection:BelongsToCollection?
    var genres: [Genres]?
    var originCountry:[String]?
    var productionCompanies : [ProductionCompanies]?
    var productionCountries: [ProductionCountries]?
    
    private enum CodingKeys : String, CodingKey {
        case adult,video,success,overview,title,homepage,tagline,status,id,budget,revenue,runtime,popularity,genres
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case statusMessage = "status_message"
        case imdbId = "imdb_id"
        case statusCode = "status_code"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case belongsToCollection = "belongs_to_collection"
        case originCountry = "origin_country"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
    }
    
}
struct BelongsToCollection:Codable {
    var id: Int?
    var name,posterPath,backdropPath: String?
    
    private enum CodingKeys : String, CodingKey {
        case id,name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
    
}
struct Genres:Codable {
    var id: Int?
    var name: String?
}

struct ProductionCompanies:Codable {
    var id: Int?
    var logoPath,name,originCountry:String?
    
    private enum CodingKeys: String, CodingKey {
        case id,name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
}

struct ProductionCountries: Codable {
    var iso31661,name: String?
    
    private enum CodingKeys: String, CodingKey {
        case iso31661 = "iso_3166_1"
        case name
    }
}
struct SpokenLanguages: Codable {
    var englishName,name,iso6391: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
        case englishName = "english_name"
        case iso6391 = "iso_639_1"
    }
}

