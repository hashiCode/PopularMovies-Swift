//
//  PopularMoviesViewController.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

import UIKit
import Combine

class PopularMoviesViewController: UIViewController {
    
    private let movieCellIdentifier = "MovieCollectionViewCell"
    
    let popularMoviesView = PopularMoviesView(frame: .zero)
    private let viewModel: PopularMoviesViewModel
    private let posterFetchService: PosterFetchService
    private var anyCancelable = Set<AnyCancellable>()
    private let spinner = SpinnerViewController()
    
    
    
    init(viewModel: PopularMoviesViewModel, posterFetchService: PosterFetchService) {
        self.viewModel = viewModel
        self.posterFetchService = posterFetchService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        self.setupSubscribers()
        self.viewModel.getNextPopularMovies()
    }

    override func loadView() {
        self.view = popularMoviesView
    }
}

extension PopularMoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.popularMoviesView.moviesCollection.dequeueReusableCell(withReuseIdentifier: movieCellIdentifier, for: indexPath) as? MovieCollectionViewCell
             else { fatalError("should have register") }
        let movie = self.viewModel.movies[indexPath.row]
        self.posterFetchService.fetchPoster(imageView: cell.posterImageView, movie: movie, size: .small)
        return cell
    }
    
}

extension PopularMoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (view.frame.width)/3
        return CGSize(width: width, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.viewModel.movies.count - 1 {
            self.viewModel.getNextPopularMovies()
        }
    }
    
}

// MARK: private methods
extension PopularMoviesViewController {
    
    private func configureCollectionView() {
        self.popularMoviesView.moviesCollection.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: movieCellIdentifier)
        self.popularMoviesView.moviesCollection.dataSource = self
        self.popularMoviesView.moviesCollection.delegate = self
    }
    
    private func setupSubscribers() {
        
        self.viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                guard self != nil else { return }
                self?.popularMoviesView.moviesCollection.reloadData()
        }.store(in: &anyCancelable)
        
        self.viewModel.$loading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (loading) in
                guard self != nil else { return }
                if loading {
                    self?.showSpinner()
                } else {
                    self?.removeSpinner()
                }
        }.store(in: &anyCancelable)
        
    }
    
    private func showSpinner() {
        self.addChild(spinner)
        self.spinner.view.frame = view.frame
        self.view.addSubview(spinner.view)
        self.spinner.didMove(toParent: self)
    }
    
    private func removeSpinner() {
        self.spinner.willMove(toParent: nil)
        self.spinner.view.removeFromSuperview()
        self.spinner.removeFromParent()
    }
}

