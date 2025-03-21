//
//  UIview.swift
//  E-Learning
//
//  Created by aya on 04/12/2024.
//

import UIKit
import Combine

protocol callDataBack {
    func sendDataBack(_ data: Any)
}

protocol sendData {
    func sendData(_ data: Any)
}

extension UIViewController {
    
    func moveToSubView<T: UIViewController>(
        mainContainerView: UIView,
        identifier: String,
        storyboardName: String? = nil,
        nibName: String? = nil,
        _ viewControllerType: T.Type,
        data: Any? = nil
    ) {
        var controller: T?
        
        if let storyboardName = storyboardName {
            // Load from storyboard
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T
        } else if let nibName = nibName {
            // Load from Nib file
            controller = T(nibName: nibName, bundle: nil)
        }
        
        guard let viewController = controller else {
            print("Failed to instantiate view controller with identifier: \(identifier)")
            return
        }
        // Pass data if the child view controller conforms to callDataBack
        if let sendDataVC = viewController as? sendData, let data = data {
            print("moveToSubView: Sending data to \(identifier): \(data)")
            sendDataVC.sendData(data)
        } else if let dataViewController = viewController as? callDataBack, let data = data {
            print("moveToSubView: Sending data back to \(identifier): \(data)")
            dataViewController.sendDataBack(data)
        } else {
            print("moveToSubView: No data protocol conformed by \(identifier)")
        }
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(viewController.view)
        self.addChild(viewController)
        
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            viewController.view.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor)
        ])
        
        viewController.didMove(toParent: self)
    }
    
    func removeAllSubView(mainContainerView: UIView) {
        mainContainerView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
}
