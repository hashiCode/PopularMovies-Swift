//
//  DetailViewModelTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class DetailViewModelTest: QuickSpec {

    override func spec() {
        
        describe("DetailViewModel") {
            var sut: DetailViewModel!
            var genreCacheMock: GenreCacheMock!
            var movieService: MoviesServiceMock!
            
            beforeEach {
                genreCacheMock = GenreCacheMock()
                movieService = MoviesServiceMock()
                sut = DetailViewModel(movie: Movie.createMovieStub(), genreCache: genreCacheMock, movieService: movieService)
            }
            
            it("should get genres name") {
                //stub movie has genres id: 1, 2
                let genresMock = [Genre(id: 1, name: "action"), Genre(id: 2, name: "adventure")]
                genreCacheMock.genres = genresMock
                
                waitUntil { done in
                    sut.getMovieGenres { (genres) in
                        expect(genres.isEmpty).to(beFalse())
                        
                        expect(genres.contains(genresMock[0].name)).to(beTrue())
                        expect(genres.contains(genresMock[1].name)).to(beTrue())
                        done()
                    }
                }
            }
            
            context("should handle favorite movie correctly"){
                
                it("when movie is not favorite") {
                    waitUntil { done in
                        sut.handleFavoriteMovie { result in
                            expect(movieService.favoriteMovieWasCalled).to(beTrue())
                            done()
                        }
                    }
                    
                }
                
                it("when movie is favorite") {
                    movieService.findMovieStub = MovieEntity()
                    waitUntil { done in
                        sut.handleFavoriteMovie { result in
                            expect(movieService.favoriteMovieWasCalled).to(beFalse())
                            done()
                        }
                    }
                    
                }
                
            }
            
        }
    }

}
