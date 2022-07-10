//
//  PhotosCollectionViewController.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 26.06.2022.
//

import UIKit
import SDWebImage

class PhotosCollectionViewController: UICollectionViewController {
    
    //MARK: - Properties
    
    let networkDataFetcher = NetworkDataFetcher()
    private var timer: Timer?
    private var photos = [UnsplashPhoto]()
    private let itemPerRow: CGFloat = 1
    private let sectionInserts = UIEdgeInsets(top: 20,
                                              left: 20,
                                              bottom: 20,
                                              right: 20)
    private var selectedImages = [UIImage]()
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
    
    //MARK: - UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBar()
        setupSearchBar()
        updateNavButtonsState()
    }
    
    //MARK: - Buttons methods
    
    @objc private func addButtonPressed() {
        
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
    
    
    //MARK: - Setup UI
    
    private func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CollectionViewImageCell.self, forCellWithReuseIdentifier: CollectionViewImageCell.reuseID)
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
    
    private func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavButtonsState()
    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
}

//MARK: - DataSource

extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewImageCell.reuseID , for: indexPath) as! CollectionViewImageCell
        let unsplashedPhotos = photos[indexPath.item]
        cell.unsplashPhoto = unsplashedPhotos
        
        return cell
    }
}

//MARK: - UISearchBarDeletage

extension PhotosCollectionViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchWord: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.photos = fetchedPhotos.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                self?.refresh()
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewImageCell
        guard let image = cell.photoImageView.image else { return }
            selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewImageCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let photo = photos[indexPath.item]
        let paddingSpace = sectionInserts.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemPerRow
        let height = CGFloat(photo.height) * widthPerItem / CGFloat(photo.width)
        return CGSize(width: widthPerItem, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
}
