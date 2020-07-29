//
//  GenreCache.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 27/07/20.
//

import Foundation
import os


class GenreCache {
    
    static let genresKey = "genres"
    
    static let shared = GenreCache()
    
    private let remoteGenreLoader: RemoteGenreLoader
    
    init(remoteGenreLoader : RemoteGenreLoader = RemoteGenreLoader(provider: MoviesDBHttpProvider(session: URLSession.shared))){
        self.remoteGenreLoader = remoteGenreLoader
        UserDefaults.standard.removeObject(forKey: GenreCache.genresKey)
        UserDefaults.standard.synchronize()
    }
    
    func loadGenres(movie: Movie, callback: @escaping GenreLoader.GenreCallback) {
        let genres = self.deserializeGenres()
        if genres.isEmpty {
            self.remoteGenreLoader.loadGenres(movie: movie) { [weak self] (genres) in
                guard let self = self else { return }
                var genresResult = genres
                if genres.isEmpty{
                    genresResult = self.loadFallbackGenres()
                }
                self.serializeGenres(genres: genresResult)
                self.handleCallback(movie: movie, genres: genresResult, callback: callback)
            }
        } else {
            self.handleCallback(movie: movie, genres: genres, callback: callback)
        }
    }
    
    private func handleCallback(movie: Movie, genres: [Genre], callback: @escaping GenreLoader.GenreCallback) {
        callback(genres.filter {(genre) -> Bool in
            return movie.genreIDS.contains(genre.id)
        })
    }
    
    private func serializeGenres(genres: [Genre]) {
        do {
            let data = try JSONEncoder().encode(genres)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: GenreCache.genresKey)
            userDefaults.synchronize()
        } catch  {
            os_log("Error serializing genres")
        }
    }
    
    private func deserializeGenres() -> [Genre] {
        let userDefault = UserDefaults.standard
        if let genresData = userDefault.data(forKey: GenreCache.genresKey) {
            do {
                let genres = try JSONDecoder().decode([Genre].self, from: genresData)
                return genres
            } catch {
                os_log("Error deserialize genres from user default")
                return self.loadFallbackGenres()
            }
        }
        return []
    }
    
    private func loadFallbackGenres() -> [Genre] {
        do {
            if let jsonPath = Bundle.main.path(forResource: "genres", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath))
                let genres = try JSONDecoder().decode([Genre].self, from: data)
                return genres
            }
        } catch {
            os_log("Error serializing genres from local json")
        }
        return []
    }
    
}
