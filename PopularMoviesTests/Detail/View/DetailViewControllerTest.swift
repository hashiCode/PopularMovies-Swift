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
    private(set) var handleFavoriteMovieWasCalled = false
    static let genres = "action, adventure"
    
    override func getMovieGenres(genresCallback: @escaping DetailViewModel.MoviesGenres) {
        getMovieGenresWasCalled = true
        genresCallback(DetailViewModelSpy.genres)
    }
    
    var shouldThrowError = false
    override func handleFavoriteMovie(callback: @escaping (Result<Movie, Error>) -> Void) {
        handleFavoriteMovieWasCalled = true
        if(shouldThrowError) {
            callback(.success(self.movie))
        } else {
            callback(.failure(MoviesServiceError.aleradyPersisted))
        }
    }
}

class DetailViewControllerTest: QuickSpec {

    override func spec() {
        describe("DetailViewController") {
            
            var sut: DetailViewController!
            var posterFetchService: PosterFetchServiceMock!
            var viewModel: DetailViewModelSpy!
            let movieStub = Movie.createMovieStub()
            var movieService: MoviesServiceMock!
            
            beforeEach {
                posterFetchService = PosterFetchServiceMock()
                movieService = MoviesServiceMock()
                viewModel = DetailViewModelSpy(movie: movieStub, genreCache: GenreCacheMock(), movieService: movieService)
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
            
            context("should handle favorite movie correctly") {
                it("should call favorite movie when right item is called") {
                    guard let rightButton = sut.navigationItem.rightBarButtonItem else {
                        fail("should have right button")
                        return
                    }
                    
                    _ = rightButton.target?.perform(rightButton.action, with: nil)
                    expect(viewModel.handleFavoriteMovieWasCalled).toEventually(beTrue())
                }
                
                it("should show alert when an error ocurren on handleFavorite") {
                    guard let rightButton = sut.navigationItem.rightBarButtonItem else {
                        fail("should have right button")
                        return
                    }
                    viewModel.shouldThrowError = true
                    _ = rightButton.target?.perform(rightButton.action, with: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        expect(sut.presentedViewController).toEventually(beAKindOf(UIAlertController.self))
                    }
                    
                }
            }
            
            
        }
    }

}
