//
//  PosterFetchServiceMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 12/07/20.
//

import UIKit
@testable import PopularMovies

class PosterFetchServiceMock: PosterFetchService {
    
    var fetchMovies = [Movie]()
    
    func fetchPoster(imageView: UIImageView, movie: Movie, size: PosterSize) {
        fetchMovies.append(movie)
    }
    

}
