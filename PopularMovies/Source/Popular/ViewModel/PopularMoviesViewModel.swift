//
//  PopularMoviesViewModel.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 07/07/20.
//

import Foundation
import Combine

protocol PopularMoviesViewModelContract {
    
    var movies: [Movie] { get }
    var moviesPublisher: Published<[Movie]>.Publisher { get }
    
    var loading: Bool { get }
    var loadingPublisher: Published<Bool>.Publisher { get }
    
    var error: Error? { get }
    var errorPublisher: Published<Error?>.Publisher { get }
    
    var hasEnded: Bool { get }
    var hasEndedPublisher: Published<Bool>.Publisher { get }
    
    var page: Int { get }
    
    func getNextPopularMovies()
    
    func refreshMovies()
    
}

class PopularMoviesViewModel: PopularMoviesViewModelContract, ObservableObject {
    
    private let movieService: MoviesService
    
    private(set) var page = 1
    
    @Published private(set) var movies = [Movie]()
    @Published private(set) var loading = false
    @Published private(set) var error: Error?
    @Published private(set) var hasEnded = false
    
    var moviesPublisher: Published<[Movie]>.Publisher { _movies.projectedValue }
    var loadingPublisher: Published<Bool>.Publisher { _loading.projectedValue }
    var errorPublisher: Published<Error?>.Publisher { _error.projectedValue }
    var hasEndedPublisher: Published<Bool>.Publisher { _hasEnded.projectedValue }
    
    
    init(service: MoviesService) {
        self.movieService = service
    }
    
    func getNextPopularMovies(){
        if (!self.hasEnded) {
            self.loading = true
            self.movieService.getPopularMovies(page: page) { [weak self] (result) in
                guard self != nil else {return}
                self?.loading = false
                switch result {
                    case .failure(let error):
                    self?.error = error
                    break
                case .success(let result):
                    if (result.isEmpty) {
                        self?.hasEnded = true
                    } else {
                        self?.page += 1
                        self?.movies.append(contentsOf: result)
                    }
                }
            }
        }
    }
    
    func refreshMovies() {
        self.page = 1
        self.movies = []
        self.hasEnded = false
        self.getNextPopularMovies()
    }

}
