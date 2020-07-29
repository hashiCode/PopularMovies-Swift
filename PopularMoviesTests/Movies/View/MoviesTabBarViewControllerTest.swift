//
//  MoviesTabBarViewControllerTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 04/07/20.
//

import XCTest
@testable import PopularMovies

class MoviesTabBarViewControllerTest: XCTestCase {
    
    var sut: MoviesTabBarViewController!

    override func setUpWithError() throws {
        sut = MoviesTabBarViewController()
    }
    
    func testTitle() throws {
        sut.viewDidLoad()
        XCTAssertEqual(sut.title, Constants.appName)
    }

    func testSetupTabsCorrectly() throws {
        sut.viewDidLoad()
        guard let viewControllers = sut.viewControllers else { fatalError() }
        XCTAssert(viewControllers.count == 2)
        
        let popularMoviesViewController = viewControllers[0]
        let favoriteMoviesViewController = viewControllers[1]
        
        XCTAssertTrue(popularMoviesViewController is PopularMoviesViewController)
        XCTAssertTrue(favoriteMoviesViewController is FavoriteMoviesViewController)
        
        let popularTabItem = popularMoviesViewController.tabBarItem
        let favoriteTabItem = favoriteMoviesViewController.tabBarItem
        
        XCTAssertEqual(popularTabItem?.title, LocalizableConstants.kPopular.localized())
        XCTAssertNotNil(popularTabItem?.image)
        XCTAssertNotNil(popularTabItem?.selectedImage)
        
        XCTAssertEqual(favoriteTabItem?.title, LocalizableConstants.kFavorites.localized())
        XCTAssertNotNil(favoriteTabItem?.image)
        XCTAssertNotNil(favoriteTabItem?.selectedImage)
        
        XCTAssertEqual(sut.navigationItem.backBarButtonItem!.title, "")
    }

}
