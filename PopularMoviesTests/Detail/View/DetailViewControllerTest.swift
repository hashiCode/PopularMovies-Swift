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
    
    private(set) var getMovieGenresWasCalled = false
    private(set) var favoriteMovieWasCalled = false
    static let genres = "action, adventure"
    
    override func getMovieGenres(genresCallback: @escaping DetailViewModel.MoviesGenres) {
        getMovieGenresWasCalled = true
        genresCallback(DetailViewModelSpy.genres)
    }
    
    override func favoriteMovie(callback: @escaping () -> Void) {
        favoriteMovieWasCalled = true
        super.favoriteMovie(callback: callback)
    }
}

class DetailViewControllerTest: QuickSpec {

    override func spec() {
        describe("DetailViewController") {
            
            var sut: DetailViewController!
            var posterFetchService: PosterFetchServiceMock!
            var viewModel: DetailViewModelSpy!
            let movieStub = Movie.createMovieStub()
            
            beforeEach {
                posterFetchService = PosterFetchServiceMock()
                viewModel = DetailViewModelSpy(movie: movieStub, genreCache: GenreCacheMock())
                sut = DetailViewController(viewModel: viewModel, posterFetchService: posterFetchService)
                _ = sut.view
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
            
            it("should call favorite movie when right item is called") {
                guard let rightButton = sut.navigationItem.rightBarButtonItem else {
                    fail("should have right button")
                    return
                }
                
                _ = rightButton.target?.perform(rightButton.action, with: nil)
                
                expect(viewModel.favoriteMovieWasCalled).to(beTrue())
            }
            
        }
    }

}
