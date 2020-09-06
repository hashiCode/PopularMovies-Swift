//
//  RemoteMoviesService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation
import UIKit
import CoreData

class MoviesServiceImpl: MoviesService {
    
    private let provider: ApiProvider

    init(provider: ApiProvider) {
        self.provider = provider
    }

    func getPopularMovies(page: Int, completion: @escaping (MoviesService.Result) -> Void) {
        let parameters = [Parameters.page: String(page)]
        self.handleRequest(endpoint: .popular, parameters: parameters, completion: completion)
    }
    
    func searchMovies(page: Int, movieName: String, completion: @escaping (MoviesService.Result) -> Void) {
        let parameters = [Parameters.page: String(page), Parameters.query : movieName]
        self.handleRequest(endpoint: .search, parameters: parameters, completion: completion)
    }
    
    private func handleRequest(endpoint: Endpoint, parameters: [String : String], completion: @escaping (MoviesService.Result) -> Void) {
        self.provider.get(endpoint: endpoint, parameters: parameters) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let result = self.mapMovies(data: data)
                completion(result)
                break
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func mapMovies(data: Data) -> MoviesService.Result {
        do {
            let movies = try MoviesMapper.map(data)
            return .success(movies)
        } catch  {
            return .failure(error)
        }
        
    }
    

    func favoriteMovie(movie: Movie) throws {
        let context = self.getContext()
        let movieEntity = MovieEntity(context: context)
        movieEntity.movieId = Int64(movie.id)
        movieEntity.title = movie.originalTitle
        movieEntity.overview = movie.overview
        movieEntity.posterPath = movie.posterPath
        movieEntity.genres = movie.genreIDS
        do {
            try context.save()
        } catch  {
            throw MoviesServiceError.aleradyPersisted
        }
        
    }
    
    func unfavoriteMovie(movie: Movie) {
        guard let movieEntity = self.findMovie(movieId: movie.id) else {
            return
        }
        let context = self.getContext()
        do {
            context.delete(movieEntity)
            try context.save()
        } catch  {
            print("error on unfavorite movie \(movieEntity.movieId)")
        }
    }
    
    func findMovie(movieId: Int) -> MovieEntity? {
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
    
    
}
