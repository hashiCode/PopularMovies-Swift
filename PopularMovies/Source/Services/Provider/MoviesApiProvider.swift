//
//  MoviesApiProvider.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//

import Foundation
import Combine

protocol MoviesApiProvider {
    
    typealias Result = Swift.Result<Data, Error>
    
    func get(page: Int, completitionHandler: @escaping (Result) -> Void)
}

class MoviesHTTPProvider: MoviesApiProvider {
    
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
    
    func get(page: Int, completitionHandler: @escaping (MoviesApiProvider.Result) -> Void) {
        let url = buildURL(page: page)
        session.dataTaskPublisher(for: url)
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
    
    private func buildURL(page: Int) -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = Constants.api.kScheme
        urlComponent.host = Constants.api.kBaseURL
        urlComponent.path = Constants.api.kPath
        let language = Bundle.main.preferredLocalizations.first!.components(separatedBy: "-")[0]
        urlComponent.queryItems = [
            URLQueryItem.init(name: Constants.api.kApiKey, value: self.apiKey),
            URLQueryItem.init(name: Constants.api.kPage, value: String(page)),
            URLQueryItem.init(name: Constants.api.kLanguage, value: language)
        ]
        guard let url = urlComponent.url else {
            fatalError("Cannot create url using")
        }
        return url
    }
    
}
