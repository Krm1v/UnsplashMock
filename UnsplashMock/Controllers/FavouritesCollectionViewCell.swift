//
//  FavouritesCollectionViewCell.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 11.07.2022.
//

import UIKit
import SDWebImage

class FavouritesCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "FavouritesCollectionViewCell"
    
    var photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        
        return imageView
    }()
    
    private let checkmark: UIImageView = {
        
        let image = UIImage(named: "checkmark2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        return imageView
    }()
    
    override var isSelected: Bool {
        
        didSet {
            updateSelectedState()
        }
    }
    
    var unsplashPhoto: UnsplashPhoto! {
        
        didSet {
            let photoURL = unsplashPhoto.urls["regular"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func setupImageView() {
        
        contentView.addSubview(photoImageView)
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupCheckmark() {
        
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor,
                                            constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor,
                                          constant: -8).isActive = true
    }
    
    func setImage(photo: UnsplashPhoto) {
        
        let photoURL = photo.urls["full"]
        guard let photoURL = photoURL, let url = URL(string: photoURL) else { return }
        photoImageView.sd_setImage(with: url, completed: nil)
    }
    
    private func updateSelectedState() {
        
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupCheckmark()
        updateSelectedState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
