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
        case genericErrorApi
    }

    var shouldReturnMovies = true
    var shouldReturnEmmpty = false
    
    private(set) var favoriteMovieWasCalled = false
    private(set) var unfavoriteMovieWasCalled = false
    var findMovieStub: MovieEntity?

    func getPopularMovies(page: Int, completion: @escaping (MoviesService.Result) -> Void) {
        handleCompletition(completion)
    }

    func searchMovies(page: Int, movieName: String, completion: @escaping (MoviesService.Result) -> Void) {
        handleCompletition(completion)
    }
    
    func favoriteMovie(movie: Movie) {
        favoriteMovieWasCalled = true
    }
    
    func unfavoriteMovie(movie: Movie) {
        unfavoriteMovieWasCalled = true
    }
    
    func findMovie(movieId: Int) -> MovieEntity? {
        return findMovieStub
    }
    
    func findAllFavoriteMovies() -> [MovieEntity] {
        return []
    }
    
    private func handleCompletition(_ completion: @escaping ((MoviesService.Result) -> Void)) {
        if shouldReturnMovies {
            if shouldReturnEmmpty {
                completion(.success([]))
            } else {
                let movie = Movie(popularity: 10, voteCount: 1, video: true, posterPath: "", id: 1, adult: false, backdropPath: "", originalLanguage: "", originalTitle: "", genreIDS: [1,2], title: "", voteAverage: 9, overview: "", releaseDate: "")
                completion(.success([movie]))
            }
        } else {
            completion(.failure(CustomError.genericErrorApi))
        }
    }

}
