//
//  MovieRepository.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
import CoreData

protocol MovieStorageDelegate {
    func saveMovie(_ movie: MovieResults)
    func fetchAllMovies() -> [MovieResults]
    func isMovieSaved(withID id: Int) -> Bool
    func deleteMovie(withID id: Int) -> Bool
}

struct MovieDataManager: MovieStorageDelegate {
    func saveMovie(_ movie: MovieResults) {
        let entity = Movie(context: MovieCoreDataStorage.shared.context)
        entity.saveData(model: movie)
        MovieCoreDataStorage.shared.saveContext()
    }

    func isMovieSaved(withID id: Int) -> Bool {
        return fetchMovie(withID: id) != nil
    }

    func fetchAllMovies() -> [MovieResults] {
        guard let results = MovieCoreDataStorage.shared.fetchManagedObject(managedObject: Movie.self) else { return [] }
        return results.map { $0.convertToMovie() }
    }

    func deleteMovie(withID id: Int) -> Bool {
        guard let movie = fetchMovie(withID: id) else { return false }
        MovieCoreDataStorage.shared.context.delete(movie)
        MovieCoreDataStorage.shared.saveContext()
        return true
    }

    private func fetchMovie(withID id: Int) -> Movie? {
        let fetchRequest = NSFetchRequest<Movie>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            return try MovieCoreDataStorage.shared.context.fetch(fetchRequest).first
        } catch {
            debugPrint("Error fetching movie with ID \(id):", error)
            return nil
        }
    }
}
