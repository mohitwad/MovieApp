//
//  NetworkLayer.swift
//  Movie
//
//  Created by Mohit on 12/12/24.
//

import UIKit

class NetworkManager{
    static let shared = NetworkManager()
    private init() {}
    
    func getAPIData<T:Codable>(type: RequestType, path: String, resultType: T.Type) async throws -> T {
        guard let requestUrl = URL(string: type.endpoint + path) else {
            throw ErrorMessage.dynamicMessage("Invalid URL Request")
        }
        var urlRequest = URLRequest.init(url: requestUrl)
        urlRequest.httpMethod = type.method
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let accessToken =  AppConstants.API.apiToken
        let bearerObj = "bearer " + accessToken
        urlRequest.setValue(bearerObj, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        do {
            let (data,response) = try await session.data(for: urlRequest)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw ErrorMessage.httpError(statusCode: httpResponse.statusCode)
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            }
            catch {
                throw ErrorMessage.dynamicMessage(error.localizedDescription)
            }
            
            
        } catch {
            if let urlError = error as? URLError, urlError.code == .timedOut {
                throw ErrorMessage.timeOut
            } else {
                throw ErrorMessage.dynamicMessage(error.localizedDescription)
            }
        }
    }
}
    
enum ErrorMessage: Error, LocalizedError {
    case timeOut
    case dynamicMessage(String)
    case networkError(code: Int, message: String)
    case invalidResponse
    case httpError(statusCode: Int)
    
    // Providing a custom description for errors
    var errorDescription: String? {
        switch self {
        case .timeOut:
            return "The request timed out. Please try again later."
        case .dynamicMessage(let message):
            return message
        case .networkError(let code, let message):
            return "Network error occurred with code \(code): \(message)"
        case .invalidResponse:
            return "Received invalid response from the server."
        case .httpError(let statusCode):
            return httpErrorMessage(for: statusCode)
        }
    }
    
    private func httpErrorMessage(for statusCode: Int) -> String {
        switch statusCode {
        case 400:
            return "Bad Request. Please check the request parameters."
        case 401:
            return "Unauthorized. Please check your authentication."
        case 403:
            return "Forbidden. You don't have permission to access this resource."
        case 404:
            return "Not Found. The requested resource could not be found."
        case 500:
            return "Internal Server Error. Something went wrong on the server."
        case 502:
            return "Bad Gateway. The server received an invalid response from the upstream server."
        case 503:
            return "Service Unavailable. The server is temporarily unavailable."
        default:
            return "HTTP Error occurred with status code: \(statusCode)"
        }
    }
    
}
