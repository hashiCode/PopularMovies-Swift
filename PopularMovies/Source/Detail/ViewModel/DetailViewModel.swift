//
//  DetailViewModel.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import UIKit

protocol DetailViewModelContract {
    
    typealias MoviesGenres = (String) -> Void
    
    var movie: Movie { get }
    
    func getMovieGenres(genresCallback: @escaping MoviesGenres)
    
    func handleFavoriteMovie(callback: @escaping (Result<Movie, Error>) -> Void)
    
    func isMovieFavorite() -> Bool
    
}

class DetailViewModel: DetailViewModelContract {
    
    private(set) var movie: Movie
    private let genreCache: GenreCache
    private let movieService: MoviesService
    
    init(movie: Movie, genreCache: GenreCache, movieService: MoviesService) {
        self.movie = movie
        self.genreCache = genreCache
        self.movieService = movieService
    }
    
    func getMovieGenres(genresCallback: @escaping MoviesGenres) {
        self.genreCache.loadGenres(movie: self.movie) { (genres) in
            let genresName = genres.map { (genre) -> String in
                return genre.name
            }
            genresCallback(genresName.joined(separator: ", "))
        }
    }
    
    func handleFavoriteMovie(callback: @escaping (Result<Movie, Error>) -> Void) {
        if self.isMovieFavorite() {
            self.movieService.unfavoriteMovie(movie: self.movie)
        } else {
            do {
                try self.movieService.favoriteMovie(movie: self.movie)
            } catch {
                callback(.failure(error))
                return
            }
            
        }
        callback(.success(self.movie))
    }
    
    func isMovieFavorite() -> Bool {
        return self.movieService.findMovie(movieId: self.movie.id) != nil
    }

}
