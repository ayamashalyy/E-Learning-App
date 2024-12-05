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

extension UIViewController {
    
    func moveToSubView<T: UIViewController>(
        mainContainerView: UIView,
        identifier: String,
        storyboardName: String,
        _ viewControllerType: T.Type,
        data: Any? = nil
    ) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: identifier) as? T else { return }
        
        // Pass data if the child view controller conforms to sendData
        if let dataViewController = controller as? sendData {
            guard let data = data else { return }
            dataViewController.sendData(data)
        }
        
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(controller.view)
        self.addChild(controller)
        
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: mainContainerView.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: mainContainerView.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: mainContainerView.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: mainContainerView.trailingAnchor)
        ])
        
        controller.didMove(toParent: self)
    }
    
    func removeAllSubView(mainContainerView: UIView) {
        mainContainerView.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
    }
    
}
