//
//  MovieDetailViewModelTestCase.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import XCTest
@testable import Movie


final class MovieDetailViewModelTestCase: XCTestCase {
    private var viewModel:MovieDetailViewModel!
    private var networkLayer:NetworkAPIService!
    
    
    override func setUp() {
        super.setUp()
        networkLayer = NetworkAPIService()
        viewModel = MovieDetailViewModel(apiService: networkLayer)
    }
    
    override func tearDown() {
        viewModel = nil
        networkLayer = nil
        super.tearDown()
    }
    private(set) var isFetching: Bindable<Bool> = Bindable(false)
    private(set) var hasNoInternetConnection: Bindable<Bool> = Bindable(false)
    private(set) var selectedMovieId: Bindable<Int> = Bindable(0)
    private(set) var movieDetails: Bindable<MovieDetailModel?> = Bindable(nil)
    
    
    
    func testisFetchingInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.isFetching.value
        
        // Assert
        XCTAssertEqual(initialValue, false, "isFecthing False")
    }
    func testLoadingInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.hasNoInternetConnection.value
        
        // Assert
        XCTAssertEqual(initialValue, false, "check loading")
    }
    func testCurrentPageInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.selectedMovieId.value
        
        // Assert
        XCTAssertEqual(initialValue, 0, "check current page")
    }
    func testMovieListInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.movieDetails.value
        
        // Assert
        XCTAssertNil(initialValue)
    }
    
    
    func testLoadMovie() {
        viewModel.fetchMovieDetails() { error in
            XCTAssertNil(error)
            XCTAssertEqual(error, ErrorMessage.timeOut.errorDescription)
        }
    }
    
}
