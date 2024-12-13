//
//  NetworkManager.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import XCTest
@testable import Movie

final class APICallTestCase: XCTestCase {
    
    
    func testSearchResult() {
        let service = MockAPICallService()
        Task {
            do {
                let result: MovieModel = try await service.getSearchedMovieList(page: 1, searchText: "test")
                XCTAssertNil(result.success)
                if let resultsCount = result.results?.count {
                    XCTAssertEqual(resultsCount, 20, "Expected 20 results.")
                }
            } catch {
                XCTAssert(error is ErrorMessage, "Expected an error of type `ErrorMessage`.")
            }
        }
    }
    
    func testDetailResult() {
        let service = MockAPICallService()
        Task {
            do {
                let result: MovieDetailModel = try await service.fetchMovieDetail(movieId: 912649)
                XCTAssertNil(result.success)
                if let id = result.id {
                    XCTAssertEqual(id, 912649)
                }
            } catch {
                XCTAssert(error is ErrorMessage, "Expected an error of type `ErrorMessage`.")
            }
        }
    }

    
}
