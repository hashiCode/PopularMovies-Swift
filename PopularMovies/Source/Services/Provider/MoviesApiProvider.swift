//
//  MoviesApiProvider.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation
import Combine

enum Endpoint {
    case popular
    case search
}

struct Parameters {
    static let page = "page"
    static let query = "query"
}

protocol MoviesApiProvider {
    
    typealias Result = Swift.Result<Data, Error>
    
    func get(endpoint: Endpoint, parameters: [String: String], completitionHandler: @escaping (Result) -> Void)
}

private struct Api {
    static let kScheme = "https"
    static let kBaseURL = "api.themoviedb.org"
    static let kPopularPath = "/3/movie/popular"
    static let kSearchPath = "/3/search/movie"
    
    
    static let kApiKey = "api_key"
    static let kPage = "page"
    static let kLanguage = "language"
    static let kQuery = "query"
}

class MoviesDBHttpProvider: MoviesApiProvider {
    
    private let session: URLSession
    private var anyCancelable = Set<AnyCancellable>()
    private let apiKey: String
    
    public init(session: URLSession) {
        self.session = session
        guard let path = Bundle.main.path(forResource: Constants.secretPlist.kApiKeyFile, ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let apiKey = dictionary[Constants.secretPlist.kApiKey] as? String else {
            fatalError("ApiKey not found")
        }
        self.apiKey = apiKey
    }
    
    func get(endpoint: Endpoint, parameters: [String : String], completitionHandler: @escaping (MoviesApiProvider.Result) -> Void) {
        switch endpoint {
        case .popular:
            guard let pageParameter = parameters[Parameters.page], let page = Int(pageParameter) else { fatalError("expected page parameter") }
            let url = buildPopularURL(page: page)
            self.doRequest(url, completitionHandler)
            break
        case .search:
            guard let pageParameter = parameters[Parameters.page], let page = Int(pageParameter) else { fatalError("expected page parameter") }
            guard let query = parameters[Parameters.query] else { fatalError("expected query parameter") }
            let url = buildSearchURL(page: page, movieName: query)
            self.doRequest(url, completitionHandler)
        }
        
    }
    
    private func doRequest(_ url: URL, _ completitionHandler: @escaping (Result<Data, Error>) -> Void) {
        self.session.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return element.data
        }
        .mapError { error in
            return error
        }
        .sink(receiveCompletion: { (completition) in
            switch completition {
            case .finished:
                break
            case .failure(let error):
                completitionHandler(.failure(error))
            }
        }) { (data) in
            completitionHandler(.success((data)))
        }.store(in: &self.anyCancelable)
    }
    
    private func buildSearchURL(page: Int, movieName: String) -> URL {
        var urlComponent = self.buidBaseURLComponents(page: page)
        urlComponent.path = Api.kSearchPath
        urlComponent.queryItems?.append(URLQueryItem.init(name: Api.kQuery, value: movieName))
        guard let url = urlComponent.url else {
            fatalError("Cannot create url using")
        }
        return url
    }
    
    private func buildPopularURL(page: Int) -> URL {
        var urlComponent = self.buidBaseURLComponents(page: page)
        urlComponent.path = Api.kPopularPath
        guard let url = urlComponent.url else {
            fatalError("Cannot create url using")
        }
        return url
    }
    
    private func buidBaseURLComponents(page: Int) -> URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = Api.kScheme
        urlComponent.host = Api.kBaseURL
        let language = Bundle.main.preferredLocalizations.first!.components(separatedBy: "-")[0]
        urlComponent.queryItems = [
            URLQueryItem.init(name: Api.kApiKey, value: self.apiKey),
            URLQueryItem.init(name: Api.kPage, value: String(page)),
            URLQueryItem.init(name: Api.kLanguage, value: language)
        ]
        return urlComponent
    }
    
}
