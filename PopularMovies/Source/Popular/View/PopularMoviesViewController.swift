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
    private let viewModel: PopularMoviesViewModelContract
    private let posterFetchService: PosterFetchService
    private var anyCancelable = Set<AnyCancellable>()
    private let spinner = SpinnerViewController()
    
    
    
    init(viewModel: PopularMoviesViewModelContract, posterFetchService: PosterFetchService) {
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
        self.configureSearchBar()
        self.setupSubscribers()
        self.viewModel.getNextMovies()
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
            self.viewModel.getNextMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { fatalError("expected to have navigationController") }
        let movie = self.viewModel.movies[indexPath.row]
        let detailCoordinator = DetailViewCoordinator(navigationController: navigationController, movie: movie)
        detailCoordinator.start()
    }
    
}

extension PopularMoviesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filter = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if filter.isEmpty {
            self.viewModel.clearSeach()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            let movieName = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if !movieName.isEmpty {
                self.viewModel.search(movieName: movieName)
            }
        }
        
        searchBar.resignFirstResponder()
    }
}

// MARK: private methods
extension PopularMoviesViewController {
    
    private func configureCollectionView() {
        guard let collectionView = self.popularMoviesView.moviesCollection else {
            fatalError("Should have collectionView")
        }
        collectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: movieCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = self.configureUIRefreshControl()
    }
    
    private func configureUIRefreshControl() -> UIRefreshControl {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        
        return refreshControl
    }
    
    @objc private func refreshMovies () {
        self.viewModel.refreshMovies()
    }
    
    private func setupSubscribers() {
        self.viewModel.moviesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (_) in
                guard let self = self else { return }
                self.popularMoviesView.moviesCollection.reloadData()
                self.popularMoviesView.moviesCollection.refreshControl?.endRefreshing()
        }.store(in: &anyCancelable)
        
        self.viewModel.loadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (loading) in
                guard let self = self else { return }
                if loading {
                    self.showSpinner()
                } else {
                    self.removeSpinner()
                }
        }.store(in: &anyCancelable)
        
        self.viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (error) in
                if let _ = error {
                    guard let self = self else { return }
                    self.showError()
                }
            }
        .store(in: &anyCancelable)
        
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
    
    private func showError() {
        let alert = self.createAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createAlert() -> UIAlertController {
        let alert = UIAlertController(title: LocalizableConstants.kAlertTitle.localized(), message: LocalizableConstants.kAlertMessage.localized(), preferredStyle: .alert)
        let retryAction = UIAlertAction(title: LocalizableConstants.kAlertTryAgainAction.localized(), style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.viewModel.getNextMovies()
        }
        alert.addAction(retryAction)
        return alert
    }
    
    private func configureSearchBar() {
        guard let searchBar = self.popularMoviesView.searchBar else {
            fatalError("Should have collectionView")
        }
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
}

