//
//  MovieDetailViewModel.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import Foundation


class MovieDetailViewModel {
    // MARK: - Properties
    private var apiService: NetworkAPIDelegate
    private(set) var isFetching: Bindable<Bool> = Bindable(false)
    private(set) var hasNoInternetConnection: Bindable<Bool> = Bindable(false)
    private(set) var selectedMovieId: Bindable<Int> = Bindable(0)
    private(set) var movieDetails: Bindable<MovieDetailModel?> = Bindable(nil)
    
    // MARK: - Initializer
    init(apiService: NetworkAPIDelegate = NetworkAPIService()) {
        self.apiService = apiService
    }
    
    // MARK: - API Call
    func fetchMovieDetails(completion:@escaping((String?)->Void)) {
        guard self.apiService.isInternetConnectionAvailable() else {
            hasNoInternetConnection.value = true
            return
        }
        hasNoInternetConnection.value = false
        isFetching.value = true
        Task {
            do {
                let result = try await self.apiService.fetchMovieDetail(movieId: selectedMovieId.value)
                DispatchQueue.main.async {
                    self.movieDetails.value = result
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
}
