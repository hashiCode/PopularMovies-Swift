//
//  NukePosterFetchService.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 12/07/20.
//

import UIKit
import Nuke

private struct Api {
    static let kScheme = "https"
    
    static let kBasePosterURL = "image.tmdb.org"
    static let kBasePosterPath = "/t/p/"
}

class NukePosterFetchService: PosterFetchService {
    
    func fetchPoster(imageView: UIImageView, movie: Movie, size: PosterSize) {
        let noImage = UIImage(named: "video.slash")
        
        if let posterPath = movie.posterPath {
            let options = ImageLoadingOptions(
                transition: .fadeIn(duration: 0.5),
                failureImage: noImage
            )
            let imageRequest = ImageRequest(url: self.buildURL(posterPath: posterPath, size: size), processors: [])
             Nuke.loadImage(with: imageRequest, options: options, into: imageView)
        } else {
            imageView.image = noImage
        }
        
    }
    
    private func buildURL(posterPath: String, size: PosterSize) -> URL {
        var urlComponent = URLComponents()
        urlComponent.scheme = Api.kScheme
        urlComponent.host = Api.kBasePosterURL
        urlComponent.path = "\(Api.kBasePosterPath)\(self.resolveSize(size))\(posterPath)"
        guard let url = urlComponent.url else {
            fatalError("Cannot create url using")
        }
        return url
    }
    
    private func resolveSize(_ size: PosterSize) -> String {
        switch size {
        case .small:
            return "w92"
        case .medium:
            return "w342"
        case .large:
            return "w500"
        }
    }
    

}
