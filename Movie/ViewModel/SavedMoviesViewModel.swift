//
//  SavedMovieViewModel.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
class SavedMoviesViewModel {
    // MARK: - Variables
        private(set) var movieList: Bindable<[MovieResults]> = Bindable([])
        private var storageManager: MovieStorageDelegate
        
        init(storageManager: MovieStorageDelegate = MovieDataManager()) {
            self.storageManager = storageManager
        }
        
        // MARK: - Fetch Data from Local Storage
        func fetchAllSavedMovies() {
            self.movieList.value = self.storageManager.fetchAllMovies()
        }
        
        // MARK: - Save/Unsave Movie Data
        func toggleSaveStatus(for movie: MovieResults, completion: ((String) -> Void)) {
            if isMovieSaved(id: movie.id ?? 0) {
                if self.storageManager.deleteMovie(withID: movie.id ?? 0) {
                    completion(MovieActionMessage.deletion.rawValue)
                } else {
                    completion(MovieActionMessage.failure.rawValue)
                }
            } else {
                self.storageManager.saveMovie(movie)
                completion(MovieActionMessage.success.rawValue)
            }
        }
        
        func isMovieSaved(id: Int) -> Bool {
            return self.storageManager.isMovieSaved(withID: id)
        }
}
