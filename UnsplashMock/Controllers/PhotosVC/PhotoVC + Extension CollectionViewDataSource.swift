//
//  PhotoVC + Extension CollectionViewDataSource.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 10.07.2022.
//

import UIKit

extension PhotosCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewImageCell.reuseID,
                                                      for: indexPath) as! CollectionViewImageCell
        let unsplashedPhotos = photos[indexPath.item]
        cell.unsplashPhoto = unsplashedPhotos
        
        return cell
    }
}
