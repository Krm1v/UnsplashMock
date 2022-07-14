//
//  CollectionViewImageCell.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 30.06.2022.
//

import UIKit
import SDWebImage

class CollectionViewImageCell: UICollectionViewCell {
    
    static let reuseID = "PhotosCell"
    
    private let checkmark: UIImageView = {
        
        let image = UIImage(named: "checkmark2")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
        
        return imageView
    }()
    
    let likesLabel: UILabel = {
        
        let likesLabel = UILabel()
        likesLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        likesLabel.textColor = .white
        likesLabel.textAlignment = .center
        likesLabel.numberOfLines = 1
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return likesLabel
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        
        didSet {
            let photoURL = unsplashPhoto.urls["regular"]
            guard let imageURL = photoURL, let url = URL(string: imageURL) else { return }
            photoImageView.sd_setImage(with: url)
        }
    }
    
    let photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        
        return imageView
    }()
    
    override var isSelected: Bool {
        
        didSet {
            updateSelectedState()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        likesLabel.text = nil
    }
    
    private func updateSelectedState() {
        
        photoImageView.alpha = isSelected ? 0.7 : 1
        checkmark.alpha = isSelected ? 1 : 0
    }
    
    private func setupCheckMark() {
        
        addSubview(checkmark)
        checkmark.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor,
                                            constant: -8).isActive = true
        checkmark.bottomAnchor.constraint(equalTo: photoImageView.bottomAnchor,
                                          constant: -8).isActive = true
    }
    
    private func setupPhotoImageView() {
        
        addSubview(photoImageView)
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setupLikesLabel() {
        
        addSubview(likesLabel)
        likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        likesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        updateSelectedState()
        setupPhotoImageView()
        setupCheckMark()
        setupLikesLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
