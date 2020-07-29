//
//  PosterFetchService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 12/07/20.
//

import UIKit

enum PosterSize {
    case small
    case medium
    case large
}

protocol PosterFetchService {
    
    func fetchPoster(imageView: UIImageView, movie: Movie, size: PosterSize)
}
