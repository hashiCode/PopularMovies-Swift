//
//  DetailViewControllerTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class DetailViewModelSpy: DetailViewModel {
    
    private(set)var getMovieGenresWasCalled = false
    static let genres = "action, adventure"
    
    override func getMovieGenres(genresCallback: @escaping DetailViewModel.MoviesGenres) {
        getMovieGenresWasCalled = true
        genresCallback(DetailViewModelSpy.genres)
    }
}

class DetailViewControllerTest: QuickSpec {

    override func spec() {
        describe("DetailViewController") {
            
            var sut: DetailViewController!
            var posterFetchService: PosterFetchServiceMock!
            let movieStub = Movie.createMovieStub()
            var window: UIWindow!
            
            
            beforeEach {
                posterFetchService = PosterFetchServiceMock()
                let viewModel = DetailViewModelSpy(movie: movieStub, genreCache: GenreCacheMock())
                sut = DetailViewController(viewModel: viewModel, posterFetchService: posterFetchService)
                window = UIWindow()
                window.addSubview(sut.view)
            }
            
            it("should load correctly"){
                expect(posterFetchService.fetchMovies.contains(where: { (movie) -> Bool in
                    return movie.id == movieStub.id
                    })).to(beTrue())
                expect(sut.overviewLabel.text).notTo(beNil())
                expect(sut.gradeLabel.text).notTo(beNil())
                expect(sut.gradeLabel.text!.contains("\(movieStub.voteAverage)")).to(beTrue())
                expect(sut.overviewText.text).to(equal(movieStub.overview))
                expect(sut.genreLabel.text).notTo(beNil())
                waitUntil { done in
                    expect(sut.genreListLabel.text).to(equal(DetailViewModelSpy.genres))
                    done()
                }
                
                
            }
            
        }
    }

}
