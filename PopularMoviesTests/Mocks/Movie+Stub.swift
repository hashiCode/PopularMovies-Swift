//
//  Movie+Stub.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import UIKit
@testable import PopularMovies

extension Movie {
    
    static func createMovieStub() -> Movie {
        return Movie(popularity: 1, voteCount: 1, video: true, posterPath: "", id: 1, adult: false, backdropPath: "", originalLanguage: "", originalTitle: "", genreIDS: [1, 2], title: "", voteAverage: 1, overview: "", releaseDate: "2020-06-05")
    }

}
