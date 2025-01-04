//
//  AssignCourseViewController.swift
//  E-Learning
//
//  Created by aya on 04/01/2025.
//

import UIKit

class AssignCourseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnerImage: UIImageView!
    @IBOutlet weak var learnerName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem = backButton
        learnerImage.layer.cornerRadius = learnerImage.frame.height / 2
        learnerImage.layer.borderWidth = 0.8
        learnerImage.layer.borderColor = UIColor(named: "second")?.cgColor
        learnerImage.clipsToBounds = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: AssignCourseCell.self)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension AssignCourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as AssignCourseCell
        cell.configure(category: "Design",
                       courseName: "Google UX Design",
                       instructorName: "Jacob Jones",
                       image: UIImage(named: "myLearning") ?? UIImage())
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
