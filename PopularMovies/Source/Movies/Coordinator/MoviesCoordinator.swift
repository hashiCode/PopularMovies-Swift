//
//  MoviesCoordinator.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

import UIKit

class MoviesCoordinator: Coordinator {
    
    private let window: UIWindow
    private let rootViewController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        let viewController = MoviesTabBarViewController()
        self.rootViewController = UINavigationController.init(rootViewController: viewController)
        
    }
    
    func start() {
        self.window.rootViewController = self.rootViewController
        self.window.makeKeyAndVisible()
    }

}
