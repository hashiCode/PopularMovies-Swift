//
//  MoviesService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//
import Foundation

public enum MoviesServiceError: Swift.Error {
    case invalidData
    case aleradyPersisted
}

protocol MoviesService {
    
    typealias Result = Swift.Result<[Movie], Error>
    
    func getPopularMovies(page: Int, completion: @escaping (Result) -> Void)
    
    func searchMovies(page: Int, movieName: String, completion: @escaping (Result) -> Void)
    
    func favoriteMovie(movie: Movie) throws
    
    func unfavoriteMovie(movie: Movie)
    
    func findMovie(movieId: Int) -> MovieEntity?

}
