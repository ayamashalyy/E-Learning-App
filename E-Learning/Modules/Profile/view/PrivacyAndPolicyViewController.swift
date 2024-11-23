//
//  PrivacyAndPolicyViewController.swift
//  E-Learning
//
//  Created by aya on 23/11/2024.
//

import UIKit

class PrivacyAndPolicyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let privacyAndPolicyVC = storyboard.instantiateViewController(withIdentifier: "PrivacyAndPolicyViewController") as? PrivacyAndPolicyViewController else {
            fatalError("PrivacyAndPolicyViewController could not be instantiated. Ensure its Storyboard ID is set.")
        }
        
    }
    

}
