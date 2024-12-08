//
//  QuizViewController.swift
//  E-Learning
//
//  Created by aya on 08/12/2024.
//

import UIKit

class QuizViewController: UIViewController {
    
    var questionNumberLabel: UILabel!
    var questionLabel: UILabel!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Lesson1 Quiz"
        let backButtonImage = UIImage(named: "Icon 1")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        
        
    }
    
    func setupConstraints() {
        
        
    }
    
    
}
