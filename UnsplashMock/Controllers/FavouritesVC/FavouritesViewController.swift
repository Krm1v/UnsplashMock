//
//  FavouritesViewController.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 27.06.2022.
//

import UIKit

class FavouritesViewController: UICollectionViewController {
    
    private lazy var deleteButton: UIBarButtonItem = {
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                           target: self,
                                           action: #selector(deleteButtonPressed))
        return deleteButton
    }()
    
    private lazy var shareButton: UIBarButtonItem = {
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareButtonPressed))
        return shareButton
    }()
    
    private let infoLabelNoPhotosYet: UILabel = {
        let label = UILabel()
        label.text = "You didn't add photos yet"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var numberOfPhotosSelected: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    
    private var selectedPhotos = [UIImage]()
    var photos = [UnsplashPhoto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavBar()
        setupLabel()
        updateNavButtonsState()
    }
    
    private func setupCollectionView() {
        
        collectionView.register(FavouritesCollectionViewCell.self,
                                forCellWithReuseIdentifier: FavouritesCollectionViewCell.reuseID)
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavBar() {
        
        let label = UILabel()
        label.text = "FAVOURITES"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textColor = UIColor(red: 128/255,
                                  green: 127/255,
                                  blue: 127/255,
                                  alpha: 1)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItems = [deleteButton, shareButton]
    }
    
    private func setupLabel() {
        
        collectionView.addSubview(infoLabelNoPhotosYet)
        infoLabelNoPhotosYet.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        infoLabelNoPhotosYet.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 50).isActive = true
    }
    
    private func updateNavButtonsState() {
        
        deleteButton.isEnabled = numberOfPhotosSelected > 0
        shareButton.isEnabled = numberOfPhotosSelected > 0
    }
    
    private func refresh() {
        
        updateNavButtonsState()
        self.selectedPhotos.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
    }
    
    private func showAlert() {
        
        let alert = UIAlertController(title: "",
                                      message: "\(selectedPhotos.count) photos will be deleted from favourites", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .default) { (action) in
            self.deleteItems()
            self.refresh()
        }
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel) { (action) in
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    private func deleteItems() {
        
        if let selectedCells = collectionView.indexPathsForSelectedItems {
            let items = selectedCells.map {$0.item}.sorted().reversed()
            for item in items {
                photos.remove(at: item)
            }
            collectionView.deleteItems(at: selectedCells)
        }
    }
    
    //MARK: - Button methods
    
    @objc private func deleteButtonPressed() {
        showAlert()
    }
    
    @objc private func shareButtonPressed(_ sender: UIBarButtonItem) {
        
        let shareController = UIActivityViewController(activityItems: selectedPhotos,
                                                       applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
}

//MARK: - CollectionView DataSource

extension FavouritesViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        
        infoLabelNoPhotosYet.isHidden = photos.count != 0
        
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavouritesCollectionViewCell.reuseID,
                                                      for: indexPath) as! FavouritesCollectionViewCell
        let unsplashPhoto = photos[indexPath.item]
        cell.unsplashPhoto = unsplashPhoto
        
        return cell
    }
}

//MARK: - CollectionViewDelegate

extension FavouritesViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! FavouritesCollectionViewCell
        guard let image = cell.photoImageView.image else { return }
        selectedPhotos.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didDeselectItemAt indexPath: IndexPath) {
        
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! FavouritesCollectionViewCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedPhotos.firstIndex(of: image) {
            selectedPhotos.remove(at: index)
        }
    }
}

//MARK: - CollectionViewFlowLayout

extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        
        return CGSize(width: width/3 - 1, height: width/3 - 1)
    }
}

