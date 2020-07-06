//
//  MoviesMapper.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation

final class MoviesMapper {
    
    private struct Root: Codable {
        let page, totalResults, totalPages: Int
        let results: [Movie]

        enum CodingKeys: String, CodingKey {
            case page
            case totalResults = "total_results"
            case totalPages = "total_pages"
            case results
        }
    }
    
    static func map(_ data: Data) throws -> [Movie] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw RemoteMoviesService.Error.invalidData
        }

        return root.results
    }
    
}
