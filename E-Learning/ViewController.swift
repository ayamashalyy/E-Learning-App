//
//  ViewController.swift
//  E-Learning
//
//  Created by aya on 18/11/2024.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let myLearningVC = MyLearningViewController()
        let profileVC = ProfileViewController()
        
        homeVC.title = "Home"
        searchVC.title = "Search"
        myLearningVC.title = "My Learning"
        profileVC.title = "Profile"
        
        self.setViewControllers([ homeVC, searchVC, myLearningVC, profileVC], animated: false)
        
        guard let items = self.tabBar.items else { return }

        let images = ["1","2","3","4"]
        let selectedImages = ["home_selected", "search_selected", "myLearning_selected", "profile_selected"]


        for (index, item) in items.enumerated() {
                    item.image = UIImage(named: images[index])
                    item.selectedImage = UIImage(named: selectedImages[index])
                }

        self.tabBar.tintColor = UIColor(named: "myCustom")
        
     
    }


}

