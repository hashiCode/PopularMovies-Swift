//
//  UINavigationControllerMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import UIKit

class UINavigationControllerMock: UINavigationController {
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: false)
    }

}
