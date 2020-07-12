//
//  Constants.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

struct Constants {
    static let appName = "Popular Movies"
    
    struct secretPlist {
        static let kApiKeyFile = "ApiSecret"
        static let kApiKey = "apiKey"
    }
    
    struct api {
        static let kScheme = "https"
        static let kBaseURL = "api.themoviedb.org"
        static let kPath = "/3/movie/popular"
        
        
        static let kApiKey = "api_key"
        static let kPage = "page"
        static let kLanguage = "language"
        
        static let kBasePosterURL = "image.tmdb.org"
        static let kBasePosterPath = "/t/p/"
    }
}
