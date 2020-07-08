//
//  PopularMoviesViewModel.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 07/07/20.
//

import Foundation
import Combine

class PopularMoviesViewModel: ObservableObject {
    
    private let movieService: MoviesService
    
    private var page = 1
    
    @Published private(set) var movies = [Movie]()
    @Published private(set) var loading = false
    @Published private(set) var error: Error?
    @Published private(set) var hasEnded = false
    
    
    init(service: MoviesService) {
        self.movieService = service
    }
    
    
    func getNextPopularMovies(){
        if (!hasEnded) {
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

}
