//
//  ApiProviderMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 05/07/20.
//
import Foundation
@testable import PopularMovies

class ApiProviderMock: ApiProvider {
    
    var movieRequestShouldReturnSuccess = true
    var genreRequestShouldReturnSuccess = true
    var genreRequestShouldReturnEmpty = false
    var customError: Error?
    var wasCalled = false
    
    func get(endpoint: Endpoint, parameters: [String: String], completitionHandler: @escaping (ApiProvider.Result) -> Void) {
        self.wasCalled = true
        switch endpoint {
        case .popular:
            self.handleResponse(completitionHandler, type: endpoint, shouldReturnSuccess: movieRequestShouldReturnSuccess, error: customError)
        case .search:
            self.handleResponse(completitionHandler, type: endpoint, shouldReturnSuccess: movieRequestShouldReturnSuccess, error: customError)
        case .genre:
            self.handleResponse(completitionHandler, type: endpoint, shouldReturnSuccess: genreRequestShouldReturnSuccess, error: customError)
        }
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
    
    fileprivate func handleResponse(_ completitionHandler: @escaping (Result<Data, Error>) -> Void, type: Endpoint, shouldReturnSuccess: Bool, error: Error?) {
        if shouldReturnSuccess {
            var data: Data
            switch type {
            case .popular:
                data = self.makeMovieData()
            case .search:
                data = self.makeMovieData()
            case .genre:
                data = self.makeGenresData()
            }
            completitionHandler(.success(data))
        } else {
            if let error = error {
                completitionHandler(.failure(error))
            } else {
                completitionHandler(.failure(URLError(.badServerResponse)))
            }
        }
    }
    
    private func makeGenresData() -> Data {
        return DataStub.createRootGenreData(genreRequestShouldReturnEmpty)
    }
    
    private func makeMovieData() -> Data {
        let movie = makeMovie(id: 1)
        let jsonObject = [
            "page" : 1,
            "total_results": 1,
            "total_pages": 1,
            "results" : [movie],
            ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: jsonObject)
        return data
    }
    

}
