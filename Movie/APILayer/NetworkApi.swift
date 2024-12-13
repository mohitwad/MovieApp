//
//  NetworkApi.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit
import SystemConfiguration

protocol NetworkAPIDelegate {
    func isInternetConnectionAvailable() -> Bool
    func getSearchedMovieList(page: Int,searchText: String) async throws -> MovieModel
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailModel
}

extension NetworkAPIDelegate {
    func isInternetConnectionAvailable() -> Bool {
        return false
    }
}

class NetworkAPIService: NetworkAPIDelegate  {
    
    
    // Check internet connection availability
    func isInternetConnectionAvailable() -> Bool {
        return Reachability.isConnectedToNetwork()
    }
    
    // Fetch searched movie list
    func getSearchedMovieList(page: Int, searchText: String) async throws -> MovieModel {
        let path = buildQueryParameters(base: "search/movie", params: [
            "query": searchText,
            "language": "en-US",
            "page": "\(page)"
        ])
        do {
            let result = try await NetworkManager.shared.getAPIData(type: .getAPI, path: path, resultType: MovieModel.self)
            return result
        } catch let error {
            throw error
        }
    }
    
    // Fetch movie details by movie ID
    func fetchMovieDetail(movieId: Int) async throws -> MovieDetailModel {
        let path = buildQueryParameters(base: "movie/\(movieId)", params: [
            "language": "en-US"
        ])
        do {
            let result = try await NetworkManager.shared.getAPIData(type: .getAPI, path: path, resultType: MovieDetailModel.self)
            return result
        } catch let error {
            throw error
        }
    }
    
    // Helper function to construct query parameters
    private func buildQueryParameters(base: String, params: [String: String]) -> String {
        var components = URLComponents(string: base)!
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components.url?.absoluteString ?? base
    }
    
}



public class Reachability {

    class func isConnectedToNetwork() -> Bool {

        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)

        return ret

    }
}
