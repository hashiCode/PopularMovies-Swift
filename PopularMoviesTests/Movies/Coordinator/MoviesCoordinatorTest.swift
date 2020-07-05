//
//  MoviesCoordinatorTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 04/07/20.
//

import XCTest
import UIKit
@testable import PopularMovies

class MoviesCoordinatorTest: XCTestCase {
    
    var sut: MoviesCoordinator!
    var window = UIWindow()
    
    override func setUpWithError() throws {
        sut = MoviesCoordinator(window: window)
    }

    func testStart() throws {
        sut.start()
        guard let rootViewController = window.rootViewController as? UINavigationController else { fatalError() }
        XCTAssertNotNil(rootViewController.viewControllers[0] is MoviesTabBarViewController)
    }


}
