//
//  GenresMapper.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import Foundation

final class GenresMapper {
    
    private struct Root: Codable {
        let genres: [Genre]
    }
    
    static func map(_ data: Data) throws -> [Genre] {
        guard let root = try? JSONDecoder().decode(Root.self, from: data) else {
            throw MoviesServiceError.invalidData
        }

        return root.genres
    }
    
}
