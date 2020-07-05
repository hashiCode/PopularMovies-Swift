//
//  PopularMoviesViewTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
import Nimble_Snapshots
import UIKit
@testable import PopularMovies

class PopularMoviesViewTest: QuickSpec {
    
    override func spec() {
        var sut: PopularMoviesView!
        
        describe("PopularMoviesView") {
            
            it("should have a valid snapshot"){
                let window = UIWindow(frame: UIScreen.main.bounds)
                sut = PopularMoviesView(frame: window.frame)
                expect(sut).to(haveValidSnapshot())
            }
            
        }
    }

}
