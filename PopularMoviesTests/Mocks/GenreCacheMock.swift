//
//  GenreCacheMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 29/07/20.
//

import UIKit
@testable import PopularMovies

class GenreCacheMock: GenreCache {
    
    var genres = [Genre]()
    
    override func loadGenres(movie: Movie, callback: @escaping ([Genre]) -> Void) {
        callback(genres)
    }

}
