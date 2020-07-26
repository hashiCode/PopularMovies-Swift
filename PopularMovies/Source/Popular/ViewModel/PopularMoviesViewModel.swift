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

    var isSearch: Bool { get }
    var movieQuery: String { get }
    
    func getNextMovies()
    
    func refreshMovies()
    
    func search(movieName: String)
    
    func clearSeach()
}

class PopularMoviesViewModel: PopularMoviesViewModelContract, ObservableObject {
    
    private let movieService: MoviesService
    
    private(set) var page = 1
    private(set) var isSearch = false
    private(set) var movieQuery = ""
    
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
    
    func getNextMovies(){
        if (!self.hasEnded) {
            if (!self.isSearch){
                self.getNextPopularMovies()
            }
            else {
                self.getNextSearchResult()
            }
        }
    }
    
    func getNextPopularMovies(){
        self.loading = true
        self.movieService.getPopularMovies(page: page) { [weak self] (result) in
            guard let self = self else {return}
            self.loading = false
            switch result {
                case .failure(let error):
                self.error = error
                break
            case .success(let result):
                if (result.isEmpty) {
                    self.hasEnded = true
                } else {
                    self.page += 1
                    self.movies.append(contentsOf: result)
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
    
    func clearSeach() {
        self.isSearch = false
        self.movieQuery = ""
        self.refreshMovies()
    }
    
    func search(movieName: String) {
        self.movieQuery = movieName
        self.page = 1
        self.isSearch = true
        self.movies = []
        self.hasEnded = false
        self.getNextSearchResult()
    }
    
    private func getNextSearchResult() {
        self.loading = true
        self.movieService.searchMovies(page: self.page, movieName: self.movieQuery) { [weak self] (result) in
            guard let self = self else {return}
            self.loading = false
            switch result {
            case .failure(let error):
                self.error = error
                break
            case .success(let result):
                if (result.isEmpty) {
                    self.hasEnded = true
                } else {
                    self.page += 1
                    self.movies.append(contentsOf: result)
                }
            }
        }
    }

}
