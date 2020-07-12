//
//  MoviesTabBarViewController.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

import UIKit

class MoviesTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabs()
        self.setupTitle()
    }
    
    private func setupTitle() {
        self.title = Constants.appName
    }
    
    private func setupTabs() {
        let moviesApiProvider = MoviesHTTPProvider(session: URLSession.shared)
        let moviesService = RemoteMoviesService(provider: moviesApiProvider)
        
        let popularMoviesViewController = PopularMoviesViewController(viewModel: PopularMoviesViewModel(service: moviesService), posterFetchService: NukePosterFetchService())
        popularMoviesViewController.tabBarItem = UITabBarItem(title: LocalizableConstants.kPopular.localized(), image: UIImage(systemName: "film"), selectedImage: UIImage(systemName: "film.fill"))
        
        
        let favoriteMoviewViewController = FavoriteMoviesViewController()
        favoriteMoviewViewController.tabBarItem = UITabBarItem(title: LocalizableConstants.kFavorites.localized(), image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        viewControllers = [popularMoviesViewController, favoriteMoviewViewController]
    }

}
