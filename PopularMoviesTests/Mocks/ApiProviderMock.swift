//
//  ApiProviderMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//
import Foundation
@testable import PopularMovies

class ApiProviderMock: MoviesApiProvider {
    
    var shouldReturnSuccess = true
    var customError: Error?
    
    func get(endpoint: Endpoint, parameters: [String: String], completitionHandler: @escaping (MoviesApiProvider.Result) -> Void) {
        self.handleResponse(completitionHandler)
    }
    
    func makeMovie(id: Int) -> [String: Any] {
        return [
            "popularity" : 9.5,
            "vote_count": 10,
            "video": true,
            "poster_path" : "poster_path",
            "id": id,
            "adult": false,
            "backdrop_path": "backdrop_path",
            "original_language": "original_language",
            "original_title": "original_title",
            "genre_ids": [1,2],
            "title": "title",
            "vote_average": 8.5,
            "overview": "overview",
            "release_date": "01/01/20"
        ]
    }
    
    fileprivate func handleResponse(_ completitionHandler: @escaping (Result<Data, Error>) -> Void) {
        if shouldReturnSuccess {
            let movie = makeMovie(id: 1)
            let jsonObject = [
                "page" : 1,
                "total_results": 1,
                "total_pages": 1,
                "results" : [movie],
                ] as [String : Any]
            let data = try! JSONSerialization.data(withJSONObject: jsonObject)
            completitionHandler(.success(data))
        } else {
            if let error = customError {
                completitionHandler(.failure(error))
            } else {
                completitionHandler(.failure(URLError(.badServerResponse)))
            }
        }
    }

}
