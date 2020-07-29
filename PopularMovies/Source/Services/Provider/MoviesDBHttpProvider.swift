//
//  MoviesDBHttpProvider.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import Foundation
import Combine

private struct Api {
    static let kScheme = "https"
    static let kBaseURL = "api.themoviedb.org"
    static let kPopularPath = "/3/movie/popular"
    static let kSearchPath = "/3/search/movie"
    static let kGenresPath = "/3/genre/movie/list"
    
    
    static let kApiKey = "api_key"
    static let kPage = "page"
    static let kLanguage = "language"
    static let kQuery = "query"
}

private struct SecretPlist {
    static let kApiKeyFile = "ApiSecret"
    static let kApiKey = "apiKey"
}

class MoviesDBHttpProvider: ApiProvider {
    
    private let session: URLSession
    private var anyCancelable = Set<AnyCancellable>()
    private let apiKey: String
    
    public init(session: URLSession) {
        self.session = session
        guard let path = Bundle.main.path(forResource: SecretPlist.kApiKeyFile, ofType: "plist"),
            let dictionary = NSDictionary(contentsOfFile: path),
            let apiKey = dictionary[SecretPlist.kApiKey] as? String else {
            fatalError("ApiKey not found")
        }
        self.apiKey = apiKey
    }
    
    func get(endpoint: Endpoint, parameters: [String : String], completitionHandler: @escaping (ApiProvider.Result) -> Void) {
        var url: URL
        switch endpoint {
        case .popular:
            guard let pageParameter = parameters[Parameters.page], let page = Int(pageParameter) else { fatalError("expected page parameter") }
            url = buildPopularURL(page: page)
            break
        case .search:
            guard let pageParameter = parameters[Parameters.page], let page = Int(pageParameter) else { fatalError("expected page parameter") }
            guard let query = parameters[Parameters.query] else { fatalError("expected query parameter") }
            url = buildSearchURL(page: page, movieName: query)
            break
        case .genre:
            url = buildGenreURL()
        }
        self.doRequest(url, completitionHandler)
        
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
        var urlComponents = self.buidBaseURLPageComponents(page: page)
        urlComponents.path = Api.kSearchPath
        urlComponents.queryItems?.append(URLQueryItem.init(name: Api.kQuery, value: movieName))
        return self.convertToURL(urlComponents: urlComponents)
    }
    
    private func buildPopularURL(page: Int) -> URL {
        var urlComponents = self.buidBaseURLPageComponents(page: page)
        urlComponents.path = Api.kPopularPath
        return self.convertToURL(urlComponents: urlComponents)
    }
    
    private func buildGenreURL() -> URL {
        var urlComponents = self.buidBaseURLPageComponents()
        urlComponents.path = Api.kGenresPath
        return self.convertToURL(urlComponents: urlComponents)
    }
    
    private func buidBaseURLPageComponents(page: Int) -> URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = Api.kScheme
        urlComponent.host = Api.kBaseURL
        let language = Bundle.main.preferredLocalizations.first
        urlComponent.queryItems = [
            URLQueryItem.init(name: Api.kApiKey, value: self.apiKey),
            URLQueryItem.init(name: Api.kPage, value: String(page)),
            URLQueryItem.init(name: Api.kLanguage, value: language)
        ]
        return urlComponent
    }
    
    private func buidBaseURLPageComponents() -> URLComponents {
        var urlComponent = URLComponents()
        urlComponent.scheme = Api.kScheme
        urlComponent.host = Api.kBaseURL
        let language = Bundle.main.preferredLocalizations.first
        urlComponent.queryItems = [
            URLQueryItem.init(name: Api.kApiKey, value: self.apiKey),
            URLQueryItem.init(name: Api.kLanguage, value: language)
        ]
        return urlComponent
    }
    
    private func convertToURL(urlComponents: URLComponents) -> URL {
        guard let url = urlComponents.url else {
            fatalError("Cannot create url using")
        }
        return url
    }
    
}
