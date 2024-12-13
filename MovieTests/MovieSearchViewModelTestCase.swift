//
//  MovieSearchViewModelTestCase.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import XCTest
@testable import Movie


final class MovieSearchViewModelTestCase: XCTestCase {
    
    private var viewModel:MovieSearchViewModel!
    private var storage:MovieDataManager!
    private var networkLayer:NetworkAPIService!
    
    
    override func setUp() {
        super.setUp()
        storage = MovieDataManager()
        networkLayer = NetworkAPIService()
        viewModel = MovieSearchViewModel(apiService: networkLayer)
    }
    
    override func tearDown() {
        viewModel = nil
        storage = nil
        super.tearDown()
    }
    
    
    func testisFetchingInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.isFetching.value
        
        // Assert
        XCTAssertEqual(initialValue, false, "isFecthing False")
    }
    func testLoadingInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.hasNoInternet.value
        
        // Assert
        XCTAssertEqual(initialValue, false, "check loading")
    }
    func testCurrentPageInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.currentPaginationPage.value
        
        // Assert
        XCTAssertEqual(initialValue, 1, "check current page")
    }
    func testMovieListInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.movies.value
        
        // Assert
        XCTAssertEqual(initialValue, [], "check empty moview array")
    }
    
    func testLoadMovie() {
        viewModel.loadMovies(for: "test") { error in
            XCTAssertNil(error)
            XCTAssertEqual(error, ErrorMessage.timeOut.errorDescription)
        }
    }
    
    func testValidateEmptyString() {
        let strEmpty = ""
        XCTAssertEqual(viewModel.validateSearchQuery(strEmpty), EmptyMessage.Search.emptyQuery)
    }
    
    func testValidateShortString() {
        let strEmpty = "t"
        XCTAssertEqual(viewModel.validateSearchQuery(strEmpty), EmptyMessage.Search.shortQuery)
    }
    func testValidateSpecialString() {
        let strEmpty = "$#tet"
        XCTAssertEqual(viewModel.validateSearchQuery(strEmpty), EmptyMessage.Search.invalidSearchQuery)
    }
    func testValidateString() {
        let strEmpty = "test"
        XCTAssertNil(viewModel.validateSearchQuery(strEmpty))
    }
    
    func testToggleStausDelete() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleMovieFavoriteStatus(movie: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.deletion.rawValue)
            XCTAssertFalse(viewModel.isMovieFavorited(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    func testToggleStausSave() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleMovieFavoriteStatus(movie: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.success.rawValue)
            XCTAssertTrue(viewModel.isMovieFavorited(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    func testToggleStausFailure() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleMovieFavoriteStatus(movie: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.failure.rawValue)
            XCTAssertTrue(viewModel.isMovieFavorited(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    
    func testMovieSaved() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        
        if let id1 = movie.id {
            XCTAssertTrue(viewModel.isMovieFavorited(id: id1))
        }else {
            XCTAssertFalse(viewModel.isMovieFavorited(id: 0))
        }
        
    }
}
