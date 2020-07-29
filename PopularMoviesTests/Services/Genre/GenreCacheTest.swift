//
//  GenreCacheTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class GenreCacheTest: QuickSpec {

    override func spec() {
        describe("GenreCache") {
            
            var sut: GenreCache!
            var apiProvider: ApiProviderMock!
            
            beforeEach {
                apiProvider = ApiProviderMock()
            }
            
            afterEach {
                UserDefaults.standard.removeObject(forKey: GenreCache.genresKey)
                UserDefaults.standard.synchronize()
            }
            
            it("should clear user default state on init"){
                UserDefaults.standard.set("any", forKey: GenreCache.genresKey)
                sut = GenreCache(remoteGenreLoader: RemoteGenreLoader(provider: apiProvider))
                expect(UserDefaults.standard.value(forKey: GenreCache.genresKey)).to(beNil())
            }
            
            context("load genres") {
                beforeEach {
                    sut = GenreCache(remoteGenreLoader: RemoteGenreLoader(provider: apiProvider))
                }
                
                it("should retrieve genres from remote loader and save on user defaults") {
                    waitUntil { done in
                        sut.loadGenres(movie: Movie.createMovieStub()) { (genres) in
                            expect(apiProvider.wasCalled).to(beTrue())
                            expect(genres.isEmpty).to(beFalse())
                            expect(UserDefaults.standard.value(forKey: GenreCache.genresKey)).notTo(beNil())
                            done()
                        }
                    }
                }
                
                it("should retrieve genres from local json when remote return empty and save on user defaults") {
                    apiProvider.genreRequestShouldReturnEmpty = true
                    let movie =  Movie(popularity: 1, voteCount: 1, video: true, posterPath: "", id: 1, adult: false, backdropPath: "", originalLanguage: "", originalTitle: "", genreIDS: [28, 12], title: "", voteAverage: 1, overview: "", releaseDate: "2020-06-05")
                    waitUntil { done in
                        sut.loadGenres(movie: movie) { (genres) in
                            expect(apiProvider.wasCalled).to(beTrue())
                            expect(genres.isEmpty).to(beFalse())
                            expect(UserDefaults.standard.value(forKey: GenreCache.genresKey)).notTo(beNil())
                            done()
                        }
                    }
                }
                
                
                it("should retrieve genres user default when genres is already cached") {
                    waitUntil { done in
                    sut.loadGenres(movie: Movie.createMovieStub()) { (genres) in
                            expect(apiProvider.wasCalled).to(beTrue())
                            done()
                        }
                    }
                    apiProvider.wasCalled = false
                    waitUntil { done in
                        sut.loadGenres(movie: Movie.createMovieStub()) { (genres) in
                            expect(apiProvider.wasCalled).to(beFalse())
                            expect(genres.isEmpty).to(beFalse())
                            expect(UserDefaults.standard.value(forKey: GenreCache.genresKey)).notTo(beNil())
                            done()
                        }
                    }
                }
            }
            
        }
    }

}
