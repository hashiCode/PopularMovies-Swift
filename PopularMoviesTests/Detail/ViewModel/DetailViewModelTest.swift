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
            
            beforeEach {
                genreCacheMock = GenreCacheMock()
                sut = DetailViewModel(movie: Movie.createMovieStub(), genreCache: genreCacheMock)
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
            
        }
    }

}
