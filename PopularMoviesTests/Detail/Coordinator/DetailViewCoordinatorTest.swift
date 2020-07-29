//
//  DetailViewCoordinatorTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Quick
import Nimble
import UIKit
@testable import PopularMovies

class DetailViewCoordinatorTest: QuickSpec {

    override func spec() {
        describe("DetailViewCoordinator") {
            
            it("should push DetailViewCoordinator") {
                let navigationController = UINavigationControllerMock()
                let sut = DetailViewCoordinator(navigationController: navigationController, movie: Movie.createMovieStub())
                sut.start()
                expect(navigationController.visibleViewController).to(beAKindOf(DetailViewController.self))
                
            }
            
        }
    }

}
