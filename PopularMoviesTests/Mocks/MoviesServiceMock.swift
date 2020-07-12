//
//  MoviesServiceMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 07/07/20.
//

import Foundation
@testable import PopularMovies

class MoviesServiceMock: MoviesService {
    
    enum CustomError: Error {
        case genericError
    }
    
    var shouldReturnMovies = true
    var shouldReturnEmmpty = false
    
    func getPopularMovies(page: Int, completion: @escaping (MoviesService.Result) -> Void) {
        if shouldReturnMovies {
            if shouldReturnEmmpty {
                completion(.success([]))
            } else {
                let movie = Movie(popularity: 10, voteCount: 1, video: true, posterPath: "", id: 1, adult: false, backdropPath: "", originalLanguage: "", originalTitle: "", genreIDS: [1,2], title: "", voteAverage: 9, overview: "", releaseDate: "")
                completion(.success([movie]))
            }
        } else {
            completion(.failure(CustomError.genericError))
        }
    }
    
    

}
