//
//  PhotosCollectionViewController.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 26.06.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
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
    
    let networkDataFetcher = NetworkDataFetcher()
    var timer: Timer?
    var photos = [UnsplashPhoto]()
    var selectedImages = [UIImage]()
    let itemPerRow: CGFloat = 1
    let sectionInserts = UIEdgeInsets(top: 20,
                                      left: 20,
                                      bottom: 20,
                                      right: 20)
    
    
    //MARK: - UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setupSearchBar()
        updateNavButtonsState()
        loadImages()
    }
    
    //MARK: - Setup UI
    
    private func setupCollectionView() {
        
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "cell")
        collectionView.register(CollectionViewImageCell.self,
                                forCellWithReuseIdentifier: CollectionViewImageCell.reuseID)
        collectionView.backgroundColor = .white
        collectionView.layoutMargins = UIEdgeInsets(top: 0,
                                                    left: 16,
                                                    bottom: 0,
                                                    right: 16)
        
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
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
    
    private func loadImages() {
        
        networkDataFetcher.fetchImages(searchWord: "Landscapes") { [weak self] (searchResults) in
            guard let fetchedPhotos = searchResults else { return }
            self?.photos = fetchedPhotos.results
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
            self?.refresh()
        }
    }
    
    func refresh() {
        
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    
    func updateNavButtonsState() {
        
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    //MARK: - Buttons methods
    
    @objc private func addButtonPressed() {
        
        let selectedPhotos = collectionView.indexPathsForSelectedItems?.reduce([], { (photosSelected, indexPath) -> [UnsplashPhoto] in
            var mutablePhotos = photosSelected
            let photo = photos[indexPath.item]
            mutablePhotos.append(photo)
            return mutablePhotos
        })
        
        let alert = UIAlertController(title: "",
                                      message: "\(selectedPhotos?.count ?? 0) photos will be added in your favourites", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add photos",
                                      style: .default) { (action) in
            let tabBar = self.tabBarController as! TabBarController
            let navVC = tabBar.viewControllers?[1] as! UINavigationController
            let favVC = navVC.topViewController as! FavouritesViewController
            
            favVC.photos.append(contentsOf: selectedPhotos ?? [])
            favVC.collectionView.reloadData()
            self.refresh()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @objc private func actionButtonPressed(_ sender: UIBarButtonItem) {
        
        let sharingController = UIActivityViewController(activityItems: selectedImages,
                                                         applicationActivities: nil)
        sharingController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        sharingController.popoverPresentationController?.barButtonItem = sender
        sharingController.popoverPresentationController?.permittedArrowDirections = .any
        present(sharingController, animated: true, completion: nil)
    }
}

