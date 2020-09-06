//
//  RemoteMoviesServiceTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//

import Quick
import Nimble
import CoreData
@testable import PopularMovies

class MoviesServiceImplTest: QuickSpec{

    override func spec() {
        var sut: MoviesServiceImpl!
        var apiProvider: ApiProviderMock!
        
        describe("RemoteMoviesService") {

            beforeEach {
                apiProvider = ApiProviderMock()
                sut = MoviesServiceImpl(provider: apiProvider)
            }
            
            afterEach {
                self.cleanDB()
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
                    apiProvider.movieRequestShouldReturnSuccess = false
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
                    apiProvider.movieRequestShouldReturnSuccess = false
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
            
            context("should favorite movie correctly") {
                it("when not already favorited") {
                    let movie = Movie.createMovieStub()
                    try! sut.favoriteMovie(movie: movie)
                    
                    expect(self.findMovie(movieId: movie.id)).notTo(beNil())
                }
                
                it("when already favorited") {
                    let movie = Movie.createMovieStub()
                    try! sut.favoriteMovie(movie: movie)
                    
                    expect { try sut.favoriteMovie(movie: movie) }.to(throwError())
                    
                }
                
            }
            
            
            context("should unfavorite movie correctly") {
                it("when already favorited") {
                    let movie = Movie.createMovieStub()
                    self.persistMovie(movie: movie)
                    
                    sut.unfavoriteMovie(movie: movie)
                    
                    expect(self.findMovie(movieId: movie.id)).to(beNil())
                }
                
                it("when not favorited") {
                    let movie = Movie.createMovieStub()
                    
                    sut.unfavoriteMovie(movie: movie)
                    
                    expect(self.findMovie(movieId: movie.id)).to(beNil())
                }
            }
            
            context("should find movie correctly") {
                it("when already persisted"){
                    let movie = Movie.createMovieStub()
                    self.persistMovie(movie: movie)
                    
                    let result = sut.findMovie(movieId: movie.id)
                    expect(result).notTo(beNil())
                }
                
                it("when not persisted"){
                    let movie = Movie.createMovieStub()
                    
                    let result = sut.findMovie(movieId: movie.id)
                    expect(result).to(beNil())
                }
            }
        }
        
    }
    
    //MARK: helper methods for test
    private func findMovie(movieId: Int) -> MovieEntity? {
        let context = self.getContext()
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "movieId == %@", String(movieId))
        
        do {
            let result = try context.fetch(request)
            return result.count > 0 ? result[0] : nil
        } catch  {
            print("error on unfavorite movie \(movieId)")
        }
        return nil
    }
    
    private func getContext() -> NSManagedObjectContext {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("should")
        }
        return appDelegate.persistentContainer.viewContext
    }
    
    private func cleanDB(){
        let context = self.getContext()
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            let result = try context.fetch(request)
            for movie in result {
                context.delete(movie)
                try context.save()
            }
        } catch  {
           
        }
    }
    
    private func persistMovie(movie: Movie) {
        let context = self.getContext()
        let movieEntity = MovieEntity(context: context)
        movieEntity.movieId = Int64(movie.id)
        
        do {
            try context.save()
        } catch  {
            print("error on favorite movie \(movie.id)")
        }
        
    }
    
}
