//
//  RequestClass.swift
//  Movie
//
//  Created by Mohit on 13/12/24.
//

import UIKit


enum RequestType {
    case getAPI
    case postAPI
}

protocol RequestDetails {
    var endpoint: String { get }
    var method: String { get }
}

extension RequestType: RequestDetails {
    var endpoint: String {
        switch self {
        default:
            return "https://api.themoviedb.org/3/"
        }
    }

    var method: String {
        switch self {
        case .getAPI:
            return "GET"
        case .postAPI:
            return "POST"
        }
    }
}
