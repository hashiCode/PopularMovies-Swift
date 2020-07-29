//
//  RemoteGenreLoader.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import Foundation

class RemoteGenreLoader: GenreLoader {
    
    let apiProvider: ApiProvider
    
    init(provider: ApiProvider) {
        self.apiProvider = provider
    }
    
    func loadGenres(movie: Movie, callback: @escaping GenreCallback) {
        let parameters = [String: String]()
        self.apiProvider.get(endpoint: .genre, parameters: parameters) { (result) in
            switch result {
            case .success(let data):
                let genres = self.mapGenres(data: data)
                callback(genres)
                break
            case .failure(_):
                callback([])
            }
        }
    }
    
    private func mapGenres(data: Data) -> [Genre] {
        do {
            let genres = try GenresMapper.map(data)
            return genres
        } catch  {
            return []
        }
        
    }
    

}
