//
//  MoviesDBHttpProviderTest.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 25/07/20.
//

import Quick
import Nimble
@testable import PopularMovies

class MoviesDBHttpProviderTest: QuickSpec {
    
    override func spec() {
        var sut: MoviesDBHttpProvider!
        
        describe("MoviesDBHttpProvider") {
            
            beforeEach {
                URLProtocolMock.responseStub = nil
                let configuration = URLSessionConfiguration.ephemeral
                configuration.protocolClasses = [URLProtocolMock.self]
                sut = MoviesDBHttpProvider(session: URLSession(configuration: configuration))
            }
            
            context("popular endpoint") {
                it("should return data on success") {
                    URLProtocolMock.responseStub = URLReponseStub(data: Data(), error: nil, response: self.validReponse())
                    var returnedData = false
                    sut.get(endpoint: .popular, parameters: [Parameters.page : "1"]) { (reponse) in
                        switch reponse {
                        case .success(_):
                            returnedData = true
                            break
                        case .failure(_):
                            break
                        }
                    }
                    expect(returnedData).toEventually(beTrue())
                }
                
                it("should return error on failure") {
                    URLProtocolMock.responseStub = URLReponseStub(data: nil, error: RemoteMoviesService.Error.invalidData, response: nil)
                    var returnedError = false
                    sut.get(endpoint: .popular, parameters: [Parameters.page : "1"]) { (reponse) in
                        switch reponse {
                        case .success(_):
                            break
                        case .failure(_):
                            returnedError = true
                            break
                        }
                    }
                    expect(returnedError).toEventually(beTrue())
                }

                it("should fail when passing invalid parameters") {
                    expect {
                        sut.get(endpoint: .popular, parameters: ["pages" : "1"]) { (reponse) in }
                    }.to(throwAssertion())
                }
            }
            
            context("search endpoint") {
                it("should return data on success") {
                    URLProtocolMock.responseStub = URLReponseStub(data: Data(), error: nil, response: self.validReponse())
                    var returnedData = false
                    sut.get(endpoint: .genre, parameters: [Parameters.page : "1", Parameters.query: "movieName"]) { (reponse) in
                        switch reponse {
                        case .success(_):
                            returnedData = true
                            break
                        case .failure(_):
                            break
                        }
                    }
                    expect(returnedData).toEventually(beTrue())
                }

                it("should return error on failure") {
                    URLProtocolMock.responseStub = URLReponseStub(data: nil, error: RemoteMoviesService.Error.invalidData, response: nil)
                    var returnedError = false
                    sut.get(endpoint: .genre, parameters: [Parameters.page : "1", Parameters.query: "movieName"]) { (reponse) in
                        switch reponse {
                        case .success(_):
                            break
                        case .failure(_):
                            returnedError = true
                            break
                        }
                    }
                    expect(returnedError).toEventually(beTrue())
                }
            }
            
            context("genre endpoint") {
                it("should return data on success") {
                   URLProtocolMock.responseStub = URLReponseStub(data: Data(), error: nil, response: self.validReponse())
                   var returnedData = false
                   sut.get(endpoint: .search, parameters: [Parameters.page : "1", Parameters.query: "movieName"]) { (reponse) in
                       switch reponse {
                       case .success(_):
                           returnedData = true
                           break
                       case .failure(_):
                           break
                       }
                   }
                   expect(returnedData).toEventually(beTrue())
               }

               it("should return error on failure") {
                   URLProtocolMock.responseStub = URLReponseStub(data: nil, error: RemoteMoviesService.Error.invalidData, response: nil)
                   var returnedError = false
                   sut.get(endpoint: .search, parameters: [Parameters.page : "1", Parameters.query: "movieName"]) { (reponse) in
                       switch reponse {
                       case .success(_):
                           break
                       case .failure(_):
                           returnedError = true
                           break
                       }
                   }
                   expect(returnedError).toEventually(beTrue())
               }

               it("should fail when passing invalid parameters") {
                   expect {
                       sut.get(endpoint: .search, parameters: [Parameters.page : "1", "querys": "movieName"]) { (reponse) in }
                   }.to(throwAssertion())

                   expect {
                       sut.get(endpoint: .search, parameters: ["pages" : "1", Parameters.query: "movieName"]) { (reponse) in }
                   }.to(throwAssertion())
               }
                
            }
        }
    }
    
    private func anyURL() -> URL{
        return URL(string: "http://teste")!
    }
    
    private func validReponse() -> URLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }

}
