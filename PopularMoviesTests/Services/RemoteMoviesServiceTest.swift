//
//  RemoteMoviesServiceTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class RemoteMoviesServiceTest: QuickSpec{

    override func spec() {
        var sut: RemoteMoviesService!
        var apiProvider: ApiProviderMock!
        
        describe("RemoteMoviesService") {

            beforeEach {
                apiProvider = ApiProviderMock()
                sut = RemoteMoviesService(provider: apiProvider)
            }
            
            context("getPopularMovies") {
            
                it("should return movies when success"){
                    var returnMovies = false
                    sut.getPopularMovies(page: 1) { (result) in
                        switch result {
                        case .success( _):
                            returnMovies = true
                            break
                        case .failure( _):
                            fail("should not happen")
                            break
                        }
                    }
                    expect(returnMovies).toEventually(beTrue())
                }
                
                it("should return error when failure"){
                    apiProvider.shouldReturnSuccess = false
                    var returnedError = false
                    sut.getPopularMovies(page: 1) { (result) in
                        switch result {
                        case .success( _):
                            fail("should not happen")
                        case .failure( _):
                            returnedError = true
                        }
                    }
                    expect(returnedError).toEventually(beTrue())
                }
                
            }
            
            context("searchMovies") {
            
                it("should return movies when success"){
                    var returnMovies = false
                    sut.searchMovies(page: 1, movieName: "movieName") { (result) in
                        switch result {
                        case .success( _):
                            returnMovies = true
                            break
                        case .failure( _):
                            fail("should not happen")
                            break
                        }
                    }
                    expect(returnMovies).toEventually(beTrue())
                }
                
                it("should return error when failure"){
                    apiProvider.shouldReturnSuccess = false
                    var returnedError = false
                    sut.searchMovies(page: 1, movieName: "movieName") { (result) in
                        switch result {
                        case .success( _):
                            fail("should not happen")
                        case .failure( _):
                            returnedError = true
                        }
                    }
                    expect(returnedError).toEventually(beTrue())
                }
                
            }
        }
        
    }
    
}
