//
//  PhotosCollectionViewController.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 26.06.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    var photos = [PhotoModel]()
    
    private lazy var addBarButtonItem: UIBarButtonItem = {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(addButtonPressed))
        return addBarButton
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        let actionBarButton = UIBarButtonItem(barButtonSystemItem: .action,
                                              target: self,
                                              action: #selector(actionButtonPressed))
        return actionBarButton
    }()
    
    //MARK: - UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .orange
        setupCollectionView()
        setupNavBar()
        setupSearchBar()
    }
    
    //MARK: - Buttons methods
    
    @objc private func addButtonPressed() {
        
    }
    
    @objc private func actionButtonPressed() {
        
    }
    
    
    //MARK: - Setup UI
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func setupNavBar() {
        let label = UILabel()
        label.text = "PHOTOS"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 128/255,
                                  green: 127/255,
                                  blue: 127/255,
                                  alpha: 1)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItems = [actionBarButtonItem, addBarButtonItem]
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = .default
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
    }
}

//MARK: - DataSource

extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        
        return cell
    }
}

//MARK: - UISearchBarDeletage

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchWord: searchText) { (searchResults) in
                searchResults?.results.map { (photo) in
                    print(photo.urls["small"])
                }
            }
        })
    }
}
