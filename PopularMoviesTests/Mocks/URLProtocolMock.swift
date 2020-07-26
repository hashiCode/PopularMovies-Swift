//
//  URLProtocolMock.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 24/07/20.
//

import Foundation

struct URLReponseStub {
    let data: Data?
    let error: Error?
    let response: URLResponse?
}

class URLProtocolMock: URLProtocol {
    
    static var responseStub: URLReponseStub?
    
    static func register() {
        URLProtocol.registerClass(URLProtocolMock.self)
    }
    
    static func unregister() {
        responseStub = nil
        URLProtocol.unregisterClass(URLProtocolMock.self)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let mockResponse = URLProtocolMock.responseStub else { return }

        if let data = mockResponse.data {
            self.client?.urlProtocol(self, didLoad: data)
        }
        
        if let reponse = mockResponse.response {
            self.client?.urlProtocol(self, didReceive: reponse, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = mockResponse.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }

}
