//
//  MovieViewModel.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation
import CoreData

class MovieSearchViewModel {
    
    // MARK: - Properties
    private var apiService: NetworkAPIDelegate
    private var databaseManager: MovieStorageDelegate
    private(set) var isFetching: Bindable<Bool> = Bindable(false)
    private(set) var hasNoInternet: Bindable<Bool> = Bindable(false)
    private(set) var currentPaginationPage: Bindable<Int> = Bindable(1)
    private(set) var movies: Bindable<[MovieResults]> = Bindable([])
    
    // MARK: - Initializer
    init(apiService: NetworkAPIDelegate = NetworkAPIService(),
         databaseManager: MovieStorageDelegate = MovieDataManager()) {
        self.apiService = apiService
        self.databaseManager = databaseManager
    }
    
    // MARK: - API Call
    func loadMovies(for query: String,completion:@escaping((String?)->Void)) {
        guard apiService.isInternetConnectionAvailable() else {
            hasNoInternet.value = true
            return
        }
        hasNoInternet.value = false
        isFetching.value = true
        Task {
            do {
                let response = try await apiService.getSearchedMovieList(page: currentPaginationPage.value, searchText: query)
                DispatchQueue.main.async {
                    if response.success == false{
                        completion(response.statusMessage)
                    }else{
                        self.movies.value = response.results ?? []
                    }
                    self.isFetching.value = false
                }
                
            } catch {
                DispatchQueue.main.async {
                    if let error = error as? ErrorMessage {
                        completion(error.errorDescription)
                    }else {
                        completion(error.localizedDescription)
                    }
                    self.isFetching.value = false
                }
            }
        }
    }
    
    //MARK: - ValidateSearch
    func validateSearchQuery(_ query: String) -> String? {
        guard !query.isEmpty else { // Validate for empty string
            return EmptyMessage.Search.emptyQuery
        }
        
        guard query.count >= 3 else { // Validate for min 3 character
            return EmptyMessage.Search.shortQuery
        }
        
        let characterSet = CharacterSet.alphanumerics.union(.whitespaces)
        guard query.rangeOfCharacter(from: characterSet.inverted) == nil else { // Validate for special character
            return EmptyMessage.Search.invalidSearchQuery
        }
        
        return nil
    }
    
    // MARK: - Save/Unsave Movie Data
    func toggleMovieFavoriteStatus(movie: MovieResults, completion: ((String) -> Void)) {
        if isMovieFavorited(id: movie.id ?? 0) {
            if databaseManager.deleteMovie(withID: movie.id ?? 0) {
                completion(MovieActionMessage.deletion.rawValue)
            } else {
                completion(MovieActionMessage.failure.rawValue)
            }
        } else {
            databaseManager.saveMovie(movie)
            completion(MovieActionMessage.success.rawValue)
        }
    }
    
    func isMovieFavorited(id: Int) -> Bool {
        return databaseManager.isMovieSaved(withID: id)
    }
}
