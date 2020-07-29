//
//  ApiProvider.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation


enum Endpoint {
    case popular
    case search
    case genre
}

struct Parameters {
    static let page = "page"
    static let query = "query"
}

protocol ApiProvider {
    
    typealias Result = Swift.Result<Data, Error>
    
    func get(endpoint: Endpoint, parameters: [String: String], completitionHandler: @escaping (Result) -> Void)
}
