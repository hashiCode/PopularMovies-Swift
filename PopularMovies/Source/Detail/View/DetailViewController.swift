//
//  DetailViewController.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import UIKit
import Lottie

class DetailViewController: UIViewController {
    
    @IBOutlet private(set) weak var posterImage: UIImageView!
    @IBOutlet private(set) weak var overviewLabel: UILabel!
    @IBOutlet private(set) weak var gradeLabel: UILabel!
    @IBOutlet private(set) weak var overviewText: UILabel!
    @IBOutlet private(set) weak var genreLabel: UILabel!
    @IBOutlet private(set) weak var genreListLabel: UILabel!
    
    
    private var viewModel: DetailViewModelContract
    private let posterFetchService: PosterFetchService
    
    init(viewModel: DetailViewModelContract, posterFetchService: PosterFetchService) {
        self.viewModel = viewModel
        self.posterFetchService = posterFetchService
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.viewContent()
    }
    
    

}

extension DetailViewController {
    
    private func setupNavigationBar() {
        self.title = self.viewModel.movie.title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: self.getFavoriteUIImage(), style: .plain, target: self, action: #selector(handleFavoriteMovie))
    }
    
    @objc
    private func handleFavoriteMovie() {
        let isMovieFavorite = self.viewModel.isMovieFavorite()
        self.viewModel.handleFavoriteMovie { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if !isMovieFavorite {
                        self.doFavoriteAnimation()
                    }
                    self.navigationItem.rightBarButtonItem?.image = self.getFavoriteUIImage()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    let alert = self.createAlert()
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: LocalizableConstants.kAlertTitle.localized(), message: LocalizableConstants.kAlreadyPersisted.localized(), preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: LocalizableConstants.kOk.localized(), style: .cancel)
        alert.addAction(dismissAction)
        return alert
    }
    
    private func getFavoriteUIImage() -> UIImage {
        let isMovieFavorite = self.viewModel.isMovieFavorite()
        let sysImage = isMovieFavorite ? "star.fill" : "star"
        return UIImage(systemName: sysImage)!
    }
    
    private func doFavoriteAnimation() {
        let animationView = AnimationView.init(name: "156-star-blast")
        animationView.frame = view.frame
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(animationView)
        animationView.play { (_) in
            animationView.removeFromSuperview()
        }
    }
    
    private func viewContent(){
        let movie = self.viewModel.movie
        self.posterFetchService.fetchPoster(imageView: self.posterImage, movie: movie, size: .large)
        self.overviewLabel.text = LocalizableConstants.kOverview.localized()
        self.gradeLabel.text = String(format: LocalizableConstants.kGrade.localized(), movie.voteAverage)
        self.overviewText.text = movie.overview
        self.genreLabel.text = LocalizableConstants.kGenres.localized()
        self.viewModel.getMovieGenres { [weak self](genres) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.genreListLabel.text = genres
            }
        }
    }
}
