//
//  MoviesService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 05/07/20.
//
import Foundation

protocol MoviesService {
    
    typealias Result = Swift.Result<[Movie], Error>
    
    func getPopularMovies(page: Int, completion: @escaping (Result) -> Void)

}
