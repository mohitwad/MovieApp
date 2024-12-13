//
//  File.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import XCTest
@testable import Movie


final class SavedMovieViewModelTestCase: XCTestCase {
    private var viewModel: SavedMoviesViewModel!
    private var mockStorageManager: MovieDataManager!
    
    
    override func setUp() {
        super.setUp()
        mockStorageManager = MovieDataManager()
        viewModel = SavedMoviesViewModel(storageManager: mockStorageManager)
    }

    override func tearDown() {
        viewModel = nil
        mockStorageManager = nil
        super.tearDown()
    }
    
    func testMovieListInitialValue() {
        // Arrange & Act
        let initialValue = viewModel.movieList.value
        
        // Assert
        XCTAssertEqual(initialValue, [], "Initial value of movieList should be an empty array.")
    }
    
   
    
    func testMovieListHasValue() {
        viewModel.fetchAllSavedMovies()
        XCTAssertTrue(!viewModel.movieList.value.isEmpty)
    }
    
    
    func testToggleStausDelete() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleSaveStatus(for: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.deletion.rawValue)
            XCTAssertFalse(viewModel.isMovieSaved(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    func testToggleStausSave() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleSaveStatus(for: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.success.rawValue)
            XCTAssertTrue(viewModel.isMovieSaved(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    func testToggleStausFailure() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        let exp = expectation(description: "Check Login is successful")
        viewModel.toggleSaveStatus(for: movie) { message in
            XCTAssertEqual(message, MovieActionMessage.failure.rawValue)
            XCTAssertTrue(viewModel.isMovieSaved(id: movie.id ?? 0), "Movie should be deleted.")
            exp.fulfill()
        }
        waitForExpectations(timeout: 1.0,handler: nil)
    }
    
    func testMovieSaved() {
        guard let movie = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        
        if let id1 = movie.id {
            XCTAssertTrue(viewModel.isMovieSaved(id: id1))
        }else {
            XCTAssertFalse(viewModel.isMovieSaved(id: 0))
        }
       
    }
    
    
}
