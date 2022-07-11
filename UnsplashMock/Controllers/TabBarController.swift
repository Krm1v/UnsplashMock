//
//  TabBarController.swift
//  UnsplashMock
//
//  Created by Владислав Баранкевич on 26.06.2022.
//

import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - UIView lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favouritesVC = FavouritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            createNavigationViewController(rootViewController: photosVC,
                                           title: "", image: setImage(imageName: "photo.fill")),
            createNavigationViewController(rootViewController: favouritesVC,
                                           title: "",
                                           image: setImage(imageName: "heart.fill"))
        ]
    }
    
    //MARK: - Private methods
    
    private func createNavigationViewController(rootViewController: UIViewController,
                                                title: String,
                                                image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
    }
    
    private func setImage(imageName: String) -> UIImage {
        
        let image = UIImage(systemName: "\(imageName)")
        return image ?? UIImage(imageLiteralResourceName: "")
    }
}
