//
//  PopularMoviesViewModel.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 07/07/20.
//

import Quick
import Nimble
import Nimble_Snapshots
import Combine

@testable import PopularMovies

class PopularMoviesViewModelTest: QuickSpec {

    override func spec() {
        var sut: PopularMoviesViewModel!
        var service: MoviesServiceMock!
        
        describe("PopularMoviesViewModel") {
            
            beforeEach {
                service = MoviesServiceMock()
                sut = PopularMoviesViewModel(service: service)
            }
            
            context("getNextPopularMovies should behave correctly") {
                
                var loadingBecomeTrue = false
                var anyCancelable = Set<AnyCancellable>()
                
                beforeEach {
                    loadingBecomeTrue = false
                    sut.$loading.sink { (loading) in
                        if (!loadingBecomeTrue && loading) {
                            loadingBecomeTrue = true
                        }
                    }.store(in: &anyCancelable)
                }
                
                it("when returning movies") {
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beFalse())
                    expect(sut.error).toEventually(beNil())
                }
                
                it("when returning empty movies") {
                    sut.getNextPopularMovies()
                    let moviesSize = sut.movies.count
                    service.shouldReturnEmmpty = true
                    loadingBecomeTrue = false
                    
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.movies.count).toEventually(equal(moviesSize))
                    expect(sut.error).toEventually(beNil())
                    
                    loadingBecomeTrue = false
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beFalse())
                    expect(sut.movies.count).toEventually(equal(moviesSize))
                    expect(sut.error).toEventually(beNil())
                }
                
                it("when returning failure") {
                    service.shouldReturnMovies = false
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beTrue())
                    expect(sut.error).toNotEventually(beNil())
                }
            }
            
            
        }
            
    }

}
