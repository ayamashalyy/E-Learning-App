//
//  ViewController.swift
//  E-Learning
//
//  Created by aya on 18/11/2024.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    private let selectedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "selectedItem")
        view.layer.cornerRadius = 15
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.tabBar.barTintColor = .white
        self.tabBar.tintColor = UIColor(named: "myCustom")
        self.tabBar.unselectedItemTintColor = .gray
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let myLearningVC = storyboard.instantiateViewController(withIdentifier: "1") as? MyLearningViewController else {
            fatalError("MyLearningViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
        
        let homeVC = HomeViewController()
        let profileVC = ProfileViewController()
        let mySearchVC = SearchViewController()
        
        homeVC.title = "Home"
        mySearchVC.title = "Search"
        myLearningVC.title = "My Learning"
        profileVC.title = "Profile"
        
        self.setViewControllers([homeVC, mySearchVC, myLearningVC, profileVC], animated: false)
        
        guard let items = self.tabBar.items else { return }
        let images = ["1", "2", "3", "4"]
        let selectedImages = ["1", "2", "3", "4"]
        
        for (index, item) in items.enumerated() {
            item.image = UIImage(named: images[index])
            item.selectedImage = UIImage(named: selectedImages[index])
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 13),
                .foregroundColor: UIColor.gray
            ]
            
            let selectedAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 13),
                .foregroundColor: UIColor(named: "myCustom") ?? .black
            ]
            
            item.setTitleTextAttributes(attributes, for: .normal)
            item.setTitleTextAttributes(selectedAttributes, for: .selected)
        }
        
        self.tabBar.tintColor = UIColor(named: "myCustom")
        
        tabBar.addSubview(selectedBackgroundView)
        tabBar.sendSubviewToBack(selectedBackgroundView)
        
        if let firstItem = tabBar.items?.first {
            updateSelectedBackground(for: firstItem, isFirstItem: true)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedItem = tabBar.selectedItem {
            updateSelectedBackground(for: selectedItem, isFirstItem: false)
        }
    }
    
    private func updateSelectedBackground(for item: UITabBarItem?, isFirstItem: Bool) {
        guard let item = item,
              let index = tabBar.items?.firstIndex(of: item) else { return }
        
        let adjustedIndex = isFirstItem ? index + 1 : index + 2
        
        guard let tabBarItemView = tabBar.subviews[safe: adjustedIndex] else { return }
        
        let iconFrame = tabBarItemView.frame
        let size = CGSize(width: iconFrame.width * 0.6, height: iconFrame.height * 0.65)
        let origin = CGPoint(
            x: iconFrame.midX - (size.width / 2),
            y: iconFrame.midY - (size.height / 2) - 8
        )
        selectedBackgroundView.frame = CGRect(origin: origin, size: size)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
