//
//  CourseManagerViewController.swift
//  E-Learning
//
//  Created by aya on 03/01/2025.
//

import UIKit

struct Learner {
    let name: String
    let coursesCompleted: Int
    let progress: Float
    let profileImage: UIImage
}


class CourseManagerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var learners: [Learner] = [
        Learner(name: "Mohamed Ahmed", coursesCompleted: 2, progress: 0.6, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Omar Nour", coursesCompleted: 4, progress: 0.4, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Mohamed Ahmed", coursesCompleted: 2, progress: 0.6, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Omar Nour", coursesCompleted: 4, progress: 0.3, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Mohamed Ahmed", coursesCompleted: 2, progress: 0.5, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Omar Nour", coursesCompleted: 4, progress: 0.9, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Mohamed Ahmed", coursesCompleted: 2, progress: 1.0, profileImage: UIImage(named: "learnerImage")!),
        Learner(name: "Omar Nour", coursesCompleted: 4, progress: 0.7, profileImage: UIImage(named: "learnerImage")!),
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Learners".localized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: LearnersCell.self)
        
    }
}


extension CourseManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learners.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as LearnersCell
        let learner = learners[indexPath.row]
        cell.configure(with: learner)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = LearnersDetailsViewController()
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
