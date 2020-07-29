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
    
}

class DetailViewModel: DetailViewModelContract {
    
    private(set) var movie: Movie
    private let genreCache: GenreCache
    
    init(movie: Movie, genreCache: GenreCache) {
        self.movie = movie
        self.genreCache = genreCache
    }
    
    func getMovieGenres(genresCallback: @escaping MoviesGenres) {
        self.genreCache.loadGenres(movie: self.movie) { (genres) in
            let genresName = genres.map { (genre) -> String in
                return genre.name
            }
            genresCallback(genresName.joined(separator: ", "))
        }
    }

}
