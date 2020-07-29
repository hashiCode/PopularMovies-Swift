//
//  DetailViewController.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 26/07/20.
//

import UIKit

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
    
    private func setupNavigationBar() {
        self.title = self.viewModel.movie.title
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
