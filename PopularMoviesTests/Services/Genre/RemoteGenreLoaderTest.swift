//
//  RemoteGenreLoaderTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class RemoteGenreLoaderTest: QuickSpec {

    override func spec() {
        describe("RemoteGenreLoader") {
            
            var sut: RemoteGenreLoader!
            var apiProvider: ApiProviderMock!
            
            beforeEach {
                apiProvider = ApiProviderMock()
                sut = RemoteGenreLoader(provider: apiProvider)
            }
            
            it("should return genres on success") {
                waitUntil { done in
                    sut.loadGenres(movie: Movie.createMovieStub()) { (genres) in
                        expect(genres.isEmpty).to(beFalse())
                        done()
                    }
                }
            }
            
            it("should return empty genres on error") {
                apiProvider.genreRequestShouldReturnSuccess = false
                waitUntil { done in
                    sut.loadGenres(movie: Movie.createMovieStub()) { (genres) in
                        expect(genres.isEmpty).to(beTrue())
                        done()
                    }
                }
            }
            
        }
    }

}
