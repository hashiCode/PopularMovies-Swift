//
//  FavoriteMoviesViewModel.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 24/09/20.
//

import Foundation
import Combine


protocol FavoriteMoviesViewModelContract {
    
    var movies: [Movie] { get }
    
    var loading: Bool { get }
    var moviesPublisher: Published<[Movie]>.Publisher { get }
}

class FavoriteMoviesViewModel: FavoriteMoviesViewModelContract, ObservableObject {
    
    private let moviesService: MoviesService
    
    @Published private(set) var movies = [Movie]()
    @Published private(set) var loading = false
    
    var moviesPublisher: Published<[Movie]>.Publisher { _movies.projectedValue }
    var loadingPublisher: Published<Bool>.Publisher { _loading.projectedValue }
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
}
