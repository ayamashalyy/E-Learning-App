//
//  ViewController.swift
//  E-Learning
//
//  Created by aya on 18/11/2024.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.tabBar.barTintColor = .white
        self.tabBar.backgroundColor = .white
        self.tabBar.tintColor = UIColor(named: "myCustom")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let myLearningVC = storyboard.instantiateViewController(withIdentifier: "1") as? MyLearningViewController else {
            fatalError("MyLearningViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        guard let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC") as? HomeViewController else {
            fatalError("HomeViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        let profileVC = ProfileViewController()
        let mySearchVC = SearchViewController()
        let navigationController = UINavigationController(rootViewController: mySearchVC)
        navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(navigationController, animated: true)
        
        homeVC.title = "Home".localized
        mySearchVC.title = "Search".localized
        myLearningVC.title = "My Learning".localized
        profileVC.title = "Profile".localized
        
        self.setViewControllers([homeVC, navigationController, myLearningVC, profileVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        let images = ["1", "2", "3", "4"]
        let selectedImages = ["image 3", "image 2", "image 6", "image 5"]
        
        for (index, item) in items.enumerated() {
            item.image = UIImage(named: images[index])
            item.selectedImage = UIImage(named: selectedImages[index])
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Roboto-Bold", size: 12) ?? .boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor.gray
            ]
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Roboto-Bold", size: 12) ?? .boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor(named: "myCustom") ?? .black
            ]
            
            item.setTitleTextAttributes(attributes, for: .normal)
            item.setTitleTextAttributes(selectedAttributes, for: .selected)
        }
    }
}
