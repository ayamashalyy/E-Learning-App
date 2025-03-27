//
//  UIViewController+Extensions.swift
//  E-Learning
//
//  Created by Aya Mashaly on 18/03/2025.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showSuccessAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Success 🎉".localized,
            message: "\(message) ✅",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default) { _ in
            completion()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Failed 😔".localized,
            message: "\(message) ❌",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default) { _ in
            completion()
        })
        self.present(alert, animated: true, completion: nil)
    }
}
