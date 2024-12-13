//
//  Movie+CoreDataProperties.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var adult: Bool
    @NSManaged public var video: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var id: Int64
    @NSManaged public var popularity: Double
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Double
    @NSManaged public var genreIds: Data?
    
    
    func saveData(model: MovieResults) {
        self.adult = model.adult ?? false
        self.video = model.video ?? false
        self.backdropPath = model.backdropPath
        self.originalLanguage = model.originalLanguage
        self.originalTitle = model.originalTitle
        self.overview = model.overview
        self.posterPath = model.posterPath
        self.releaseDate = model.releaseDate
        self.title = model.title
        self.id = Int64(model.id ?? 0)
        self.popularity = model.popularity ?? 0.0
        self.voteAverage = model.voteAverage ?? 0.0
        let idData = try? JSONEncoder().encode(model.genreIds ?? [])
        self.genreIds = idData
    }
    func convertToMovie() -> MovieResults
    {
        var movieModel = MovieResults()
        movieModel.adult = self.adult
        movieModel.video = self.video
        movieModel.backdropPath = self.backdropPath
        movieModel.originalLanguage = self.originalLanguage
        movieModel.originalTitle = self.originalTitle
        movieModel.overview = self.overview
        movieModel.posterPath = self.posterPath
        movieModel.releaseDate = self.releaseDate
        movieModel.title = self.title
        movieModel.id = Int(self.id)
        movieModel.popularity = self.popularity
        movieModel.voteAverage = self.voteAverage
        if let data = self.genreIds{
            movieModel.genreIds = try? JSONDecoder().decode([Int].self, from: data)
        }
        return movieModel
    }

}

extension Movie : Identifiable {

}
