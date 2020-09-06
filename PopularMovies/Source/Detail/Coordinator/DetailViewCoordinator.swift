//
//  DetailViewCoordinator.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import UIKit

class DetailViewCoordinator: Coordinator {
    
    private let navigationController: UINavigationController
    private let movie: Movie
    
    init(navigationController: UINavigationController, movie: Movie){
        self.navigationController = navigationController
        self.movie = movie
    }
    
    func start() {
        let viewModel = DetailViewModel(movie: self.movie, genreCache: GenreCache.shared, movieService: MoviesServiceImpl(provider: MoviesDBHttpProvider(session: URLSession.shared)))
        let viewController = DetailViewController(viewModel: viewModel, posterFetchService: NukePosterFetchService())
        self.navigationController.pushViewController(viewController, animated: true)
    }
    

}
