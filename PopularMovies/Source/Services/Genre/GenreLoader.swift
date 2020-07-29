//
//  GenreLoader.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import Foundation

protocol GenreLoader {
    
    typealias GenreCallback = ([Genre]) -> Void
    
    func loadGenres(movie: Movie, callback: @escaping GenreCallback)
}
