//
//  PopularMoviesViewControllerTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
import Nimble_Snapshots
@testable import PopularMovies

class PopularMoviesViewControllerTest: QuickSpec {

    override func spec() {
        var sut: PopularMoviesViewController!
        
        describe("PopularMoviesViewController") {
            
            it("view instance should be PopularMoviesView") {
                sut = PopularMoviesViewController()
                expect(sut.view).to(beAKindOf(PopularMoviesView.self))
            }
        }
    }

}
