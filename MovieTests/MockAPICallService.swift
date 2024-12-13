//
//  MockAPICallService.swift
//  MovieTests
//
//  Created by Mohit on 13/12/24.
//

import Foundation
@testable import Movie

class MockAPICallService:NetworkAPIDelegate  {
    
    
    func getSearchedMovieList(page: Int, searchText: String) async throws -> MovieModel {
        guard let jsonData = readLocalJsonFile(name: "MoviesList") else {
            throw ErrorMessage.dynamicMessage("No data")
        }
        do {
            let obj = try  JSONDecoder().decode(MovieModel.self, from: jsonData)
            return obj
        } catch let error {
            throw error
        }
    }
    
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailModel {
        guard let jsonData = readLocalJsonFile(name: "MovieDetail") else {
            throw ErrorMessage.dynamicMessage("No data")
        }
        do {
            let obj = try  JSONDecoder().decode(MovieDetailModel.self, from: jsonData)
            return obj
        } catch let error {
            throw error
        }
    }
    
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
}
