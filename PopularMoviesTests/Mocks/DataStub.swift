//
//  DataStub.swift
//  PopularMoviesTests
//
//  Created by Scott Takahashi on 28/07/20.
//

import Foundation

class DataStub {
    
    static let genres = [
        ["id":1, "name": "action"],
        ["id":2, "name": "adventure"],
        ["id":3, "name": "drama"]
    ]
    
    static func createRootGenreData(_ shouldReturnEmpty: Bool = false) -> Data {
        let jsonObject = [
            "genres" : shouldReturnEmpty ? [] : genres
        ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: jsonObject)
        return data
    }
    
    static func createGenreData() -> Data {
        let data = try! JSONSerialization.data(withJSONObject: genres)
        return data
    }

}
