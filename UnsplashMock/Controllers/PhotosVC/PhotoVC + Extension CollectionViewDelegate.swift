//
//  PhotoVC + Extension CollectionViewDelegate.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 10.07.2022.
//

import UIKit

extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewImageCell
        guard let image = cell.photoImageView.image else { return }
        selectedImages.append(image)
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didDeselectItemAt indexPath: IndexPath) {
        
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewImageCell
        guard let image = cell.photoImageView.image else { return }
        if let index = selectedImages.firstIndex(of: image) {
            selectedImages.remove(at: index)
        }
    }
}
