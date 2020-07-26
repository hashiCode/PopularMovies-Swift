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
    

}
