//
//  PopularMoviesViewControllerTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
import Nimble_Snapshots
@testable import PopularMovies

class PopularMoviesViewModelMock: PopularMoviesViewModel {
    
    var getNextPopularMoviesCountCalls = 0
    var searchCalled = false
    var clearSearchCalled = false
    
    override func getNextPopularMovies() {
        self.getNextPopularMoviesCountCalls += 1
        super.getNextPopularMovies()
    }
    
    override func search(movieName: String) {
        self.searchCalled = true
    }
    
    override func clearSeach() {
        self.clearSearchCalled = true
    }
}

class PopularMoviesViewControllerTest: QuickSpec {

    override func spec() {
        var sut: PopularMoviesViewController!
        var viewModel: PopularMoviesViewModelMock!
        var movieService: MoviesServiceMock!
        var posterService: PosterFetchServiceMock!
        var window: UIWindow!
        
        describe("PopularMoviesViewController") {
            
            beforeEach {
                movieService = MoviesServiceMock()
                posterService = PosterFetchServiceMock()
                viewModel = PopularMoviesViewModelMock(service: movieService)
                sut = PopularMoviesViewController(viewModel: viewModel, posterFetchService: posterService)
                window = UIWindow()
                window.addSubview(sut.view)
                
            }
            
            it("view instance should be PopularMoviesView") {
                expect(sut.view).to(beAKindOf(PopularMoviesView.self))
            }
            
            context("viewDidLoad") {
                
                it("should have called getNextPopularMovies") {
                    expect(viewModel.getNextPopularMoviesCountCalls).to(equal(1))
                }
                
                it("should have setup collectionview correctly") {
                    let collectionView = sut.popularMoviesView.moviesCollection!
                    expect(collectionView.dataSource).to(beAnInstanceOf(PopularMoviesViewController.self))
                    expect(collectionView.delegate).to(beAnInstanceOf(PopularMoviesViewController.self))
                    expect(collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: IndexPath(row: 0, section: 0))).notTo(beNil())
                    expect(collectionView.refreshControl).notTo(beNil())
                    expect(collectionView.refreshControl?.actions(forTarget: sut.self, forControlEvent: .valueChanged)?.count).to(equal(1))
                    expect(collectionView.refreshControl?.actions(forTarget: sut.self, forControlEvent: .valueChanged)![0]).to(equal("refreshMovies"))
                }
                
            }
            
            context("collectionview datasource") {
                
                it("should numberOfItemsInSection equal to viewmodel movies") {
                    let count = sut.collectionView(sut.popularMoviesView.moviesCollection, numberOfItemsInSection: 0)
                    expect(count).to(equal(viewModel.movies.count))
                }
                
                it("should setup cell correctly") {
                    let _ = sut.collectionView(sut.popularMoviesView.moviesCollection, cellForItemAt: IndexPath(row: 0, section: 0))
                    expect(posterService.fetchMovies.isEmpty).to(beFalse())
                }
            }
            
            context("collectionview delegate") {
                
                it("should set correct size of collection view cell") {
                    let size = sut.collectionView(sut.popularMoviesView.moviesCollection, layout: sut.popularMoviesView.moviesCollection.collectionViewLayout, sizeForItemAt: IndexPath(row: 0, section: 0))
                    expect(size.width).to(equal(sut.view.frame.width/3))
                    expect(size.height).to(equal(180))
                }
                
                it("should call getNextPopularMovies when rendering last movie") {
                    sut.collectionView(sut.popularMoviesView.moviesCollection, willDisplay: MovieCollectionViewCell(), forItemAt: IndexPath(row: 0, section: 0))
                    expect(viewModel.getNextPopularMoviesCountCalls).to(equal(2))
                }
            }
            
            context("Error") {
                
                it("should show alert when viewmodel return error") {
                    movieService.shouldReturnMovies = false
                    viewModel.getNextPopularMovies()
                    
                    expect(sut.presentedViewController).toEventually(beAKindOf(UIAlertController.self))
                    
                }
                
            }
            
            context("search") {
                
                it("should have setup searchbar correctly") {
                    let searchbar = sut.popularMoviesView.searchBar
                    
                    expect(searchbar?.delegate).to(beAKindOf(PopularMoviesViewController.self))
                    expect(searchbar?.returnKeyType).to(equal(.done))
                }
                
                context("searchbar delegate") {
                    
                    it("should call viewModel#search when searchText is not empty") {
                        sut.searchBar(sut.popularMoviesView.searchBar, textDidChange: "any movie")
                        expect(viewModel.clearSearchCalled).to(beFalse())
                    }
                    
                    it("should call viewModel#clearSearch when searchText is empty") {
                        sut.searchBar(sut.popularMoviesView.searchBar, textDidChange: "")
                        expect(viewModel.clearSearchCalled).to(beTrue())
                    }
                    
                    it("should behave correctly when search button is clicked and search bar is not empty") {
                        sut.popularMoviesView.searchBar.text = "any movie"
                        sut.searchBarSearchButtonClicked(sut.popularMoviesView.searchBar)
                        
                        expect(viewModel.searchCalled).to(beTrue())
                        expect(sut.popularMoviesView.searchBar.isFirstResponder).to(beFalse())
                    }
                    
                    it("should behave correctly when search button is clicked and search bar is empty") {
                        sut.searchBarSearchButtonClicked(sut.popularMoviesView.searchBar)
                        
                        expect(viewModel.searchCalled).to(beFalse())
                        expect(sut.popularMoviesView.searchBar.isFirstResponder).to(beFalse())
                    }
                    
                }
                
            }
            
        }
    }

}
