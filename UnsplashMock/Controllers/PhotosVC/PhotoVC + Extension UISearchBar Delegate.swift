//
//  PhotoVC + UISearchBar Delegate.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 10.07.2022.
//

import UIKit

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
}
