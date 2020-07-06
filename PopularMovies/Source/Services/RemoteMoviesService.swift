//
//  RemoteMoviesService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation

class RemoteMoviesService: MoviesService {
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private let provider: MoviesApiProvider

    init(provider: MoviesApiProvider) {
        self.provider = provider
    }

    func getPopularMovies(page: Int, completion: @escaping (MoviesService.Result) -> Void) {
        self.provider.get(page: page) { [weak self] (result) in
            guard self != nil else { return }
            switch result {
            case .success(let data):
                completion(self!.mapMovies(data: data))
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
    

}
