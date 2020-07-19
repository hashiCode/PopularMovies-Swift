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
        var anyCancelable = Set<AnyCancellable>()
        
        describe("PopularMoviesViewModel") {
            
            beforeEach {
                service = MoviesServiceMock()
                sut = PopularMoviesViewModel(service: service)
            }
            
            context("getNextPopularMovies should behave correctly") {
                
                var loadingBecomeTrue = false
                
                beforeEach {
                    loadingBecomeTrue = false
                    sut.loadingPublisher.sink { (loading) in
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
                    expect(sut.page).toEventually(equal(2))
                    expect(sut.hasEnded).toEventually(beFalse())
                }
                
                it("when returning empty movies") {
                    let moviesSize = sut.movies.count
                    service.shouldReturnEmmpty = true
                    loadingBecomeTrue = false
                    
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.movies.count).toEventually(equal(moviesSize))
                    expect(sut.error).toEventually(beNil())
                    expect(sut.page).toEventually(equal(1))
                    expect(sut.hasEnded).toEventually(beTrue())
                }
                
                it("when returning failure") {
                    service.shouldReturnMovies = false
                    sut.getNextPopularMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beTrue())
                    expect(sut.error).toNotEventually(beNil())
                    expect(sut.page).toEventually(equal(1))
                    expect(sut.hasEnded).toEventually(beFalse())
                }
            }
            
            context("refreshMovies should behave correctly") {

                var hasEndedReseted = false
                var moviesReseted = false
                
                beforeEach {
                    sut.hasEndedPublisher.sink { (hasEnded) in
                        if(!hasEnded) {
                            hasEndedReseted = true
                        }
                    }.store(in: &anyCancelable)
                    
                    sut.moviesPublisher.sink { (movies) in
                        if(movies.isEmpty) {
                            moviesReseted = true
                        }
                    }.store(in: &anyCancelable)
                }
                
                it("should reset page and movies") {
                    sut.getNextPopularMovies()

                    sut.refreshMovies()
                    expect(sut.page).toEventually(equal(2))
                    expect(hasEndedReseted).toEventually(beTrue())
                    expect(moviesReseted).toEventually(beTrue())
                }
                
            }
            
        }
            
    }

}
