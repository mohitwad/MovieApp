//
//  SavedMovieViewModelTestCase.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//


import XCTest
@testable import Movie


final class DataBaseUnitTestCase: XCTestCase {
    
    var storageManager: MovieDataManager!
    
    override func setUp() {
        super.setUp()
        storageManager = MovieDataManager()
    }
    
    override func tearDown() {
        storageManager = nil
        super.tearDown()
    }
    
    func testCreateMovie() {
        guard let movie1 = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        guard let movie2 = getMovieResult(name: "MovieModel2") else {
            return XCTFail("File Not avaliable")
        }
        storageManager.saveMovie(movie1)
        storageManager.saveMovie(movie2)
        XCTAssertNotEqual(storageManager.fetchAllMovies().count, 0)
    }
    func testMovieSaved() {
        guard let movie1 = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        guard let movie2 = getMovieResult(name: "MovieModel2") else {
            return XCTFail("File Not avaliable")
        }
        
        if let id1 = movie1.id {
            XCTAssertTrue(storageManager.isMovieSaved(withID: id1))
        }else {
            XCTFail("Id not found")
        }
        if let id2 = movie2.id {
            XCTAssertTrue(storageManager.isMovieSaved(withID: id2))
        }else {
            XCTFail("Id not found")
        }
       
    }
    
    func testdeleteMovie() {
        guard let movie1 = getMovieResult(name: "MovieModel1") else {
            return XCTFail("File Not avaliable")
        }
        
        if let id1 = movie1.id {
            XCTAssertTrue(storageManager.isMovieSaved(withID: id1))
        }else {
            XCTFail("Id not found")
        }
        XCTAssertTrue(storageManager.deleteMovie(withID: movie1.id ?? 0))
        XCTAssertFalse(storageManager.deleteMovie(withID: 23))
       
    }
    
    
    
}

extension XCTestCase {
    private func readLocalJsonFile(name: String) -> Data? {
        do {
            guard let fileUrl =  Bundle.main.url(forResource: name, withExtension: "json") else {
                return nil
            }
            let data = try Data(contentsOf: fileUrl)
            return data
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getMovieResult(name: String) -> MovieResults? {
        guard let jsonData = readLocalJsonFile(name: name) else {
            return nil
        }
        do {
            let obj = try  JSONDecoder().decode(MovieResults.self, from: jsonData)
            return obj
        } catch {
            return nil
        }
    }
}
