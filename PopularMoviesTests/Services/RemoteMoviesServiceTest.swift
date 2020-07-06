//
//  RemoteMoviesServiceTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
import Nimble_Snapshots
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
            
            it("should return movies when success"){
                var returnMovies = false
                sut.getPopularMovies(page: 1) { (result) in
                    
                    switch result {
                    case .success(let movies):
                        returnMovies = !movies.isEmpty
                        break
                    case .failure( _):
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
                        fatalError("shuld not happen")
                    case .failure( _):
                        returnedError = true
                    }
                }
                expect(returnedError).toEventually(beTrue())
            }
        }
        
    }

}
