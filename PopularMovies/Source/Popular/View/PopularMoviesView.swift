//
//  PopularMoviesView.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//

import UIKit

class PopularMoviesView: UIView {
    
    private(set) var searchBar: UISearchBar!
    private(set) var moviesCollection: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        let collectionViewLayout = UICollectionViewFlowLayout.init()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumInteritemSpacing = 0;
        self.moviesCollection = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        self.searchBar = UISearchBar()
        self.addSubview(searchBar)
        self.addSubview(moviesCollection)
        self.setupConstraints()
        self.setupProperties()
      
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.setupSearchBarConstraints()
        self.setupCollectionViewConstraints()
    }
    
    private func setupSearchBarConstraints() {
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBar.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    private func setupCollectionViewConstraints() {
        self.moviesCollection.translatesAutoresizingMaskIntoConstraints = false
        
        self.moviesCollection.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.moviesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.moviesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.moviesCollection.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupProperties() {
        self.backgroundColor = UIColor.systemBackground
        self.moviesCollection.backgroundColor = UIColor.systemBackground
    }

}
