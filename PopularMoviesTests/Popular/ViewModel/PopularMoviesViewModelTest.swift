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
            
            context("getNextMovies should behave correctly when isSearch = false") {
                
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
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beFalse())
                    expect(sut.error).toEventually(beNil())
                    expect(sut.page).toEventually(equal(2))
                    expect(sut.hasEnded).toEventually(beFalse())
                    expect(sut.isSearch).toEventually(beFalse())
                }
                
                it("when returning empty movies") {
                    let moviesSize = sut.movies.count
                    service.shouldReturnEmmpty = true
                    loadingBecomeTrue = false
                    
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.movies.count).toEventually(equal(moviesSize))
                    expect(sut.error).toEventually(beNil())
                    expect(sut.page).toEventually(equal(1))
                    expect(sut.hasEnded).toEventually(beTrue())
                    expect(sut.isSearch).toEventually(beFalse())
                }
                
                it("when returning failure") {
                    service.shouldReturnMovies = false
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beTrue())
                    expect(sut.error).toNotEventually(beNil())
                    expect(sut.page).toEventually(equal(1))
                    expect(sut.hasEnded).toEventually(beFalse())
                    expect(sut.isSearch).toEventually(beFalse())
                }
            }
            
            context("getNextMovies should behave correctly when isSearch = true") {
                var loadingBecomeTrue = false
                
                beforeEach {
                    sut.search(movieName: "any movie")
                    loadingBecomeTrue = false
                    sut.loadingPublisher.sink { (loading) in
                        if (!loadingBecomeTrue && loading) {
                            loadingBecomeTrue = true
                        }
                    }.store(in: &anyCancelable)
                }
                
                it("when returning movies") {
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.isEmpty).toEventually(beFalse())
                    expect(sut.error).toEventually(beNil())
                    expect(sut.page).toEventually(equal(3))
                    expect(sut.hasEnded).toEventually(beFalse())
                    expect(sut.isSearch).toEventually(beTrue())
                }
                
                it("when returning empty movies") {
                    let moviesSize = sut.movies.count
                    service.shouldReturnEmmpty = true
                    loadingBecomeTrue = false
                    
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.movies.count).toEventually(equal(moviesSize))
                    expect(sut.error).toEventually(beNil())
                    expect(sut.page).toEventually(equal(2))
                    expect(sut.hasEnded).toEventually(beTrue())
                    expect(sut.isSearch).toEventually(beTrue())
                }
                
                it("when returning failure") {
                    let moviesCountBefore = sut.movies.count
                    service.shouldReturnMovies = false
                    sut.getNextMovies()
                    expect(loadingBecomeTrue).toEventually(beTrue())
                    expect(sut.loading).toEventually(beFalse())
                    expect(sut.movies.count).toEventually(equal(moviesCountBefore))
                    expect(sut.error).toNotEventually(beNil())
                    expect(sut.page).toEventually(equal(2))
                    expect(sut.hasEnded).toEventually(beFalse())
                    expect(sut.isSearch).toEventually(beTrue())
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
            
            context("search movies") {

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
                
                it("should behave correctly") {
                    let query = "any movie"
                    sut.search(movieName: query)
                    
                    expect(sut.movieQuery).to(equal(query))
                    expect(sut.page).to(equal(2))
                    expect(sut.isSearch).to(beTrue())
                    expect(hasEndedReseted).toEventually(beTrue())
                    expect(moviesReseted).toEventually(beTrue())
                }
                
            }
            
            context("clear search should behave correctly") {

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
                    sut.clearSeach()

                    expect(sut.isSearch).to(beFalse())
                    expect(sut.movieQuery.isEmpty).to(beTrue())
                    expect(sut.page).toEventually(equal(2))
                    expect(hasEndedReseted).toEventually(beTrue())
                    expect(moviesReseted).toEventually(beTrue())
                }
                
            }
            
        }
            
    }

}
