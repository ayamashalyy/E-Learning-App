//
//  CourseManagerViewController.swift
//  E-Learning
//
//  Created by aya on 03/01/2025.
//

import UIKit



class CourseManagerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let learnersViewModel = LearnersViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationItem.title = "Learners".localized
        
        // Setup Activity Indicator
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: LearnersCell.self)
        fetchLearners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLearners()
    }
    
    private func fetchLearners() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        
        learnersViewModel.fetchLearners { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            
            switch result {
            case .success:
                self.tableView.reloadData()
            case .failure(let error):
                showErrorAlert(message:  "Failed to load learners: \(error.localizedDescription)", completion: {})
            }
        }
    }
}


extension CourseManagerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnersViewModel.numberOfLearners()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as LearnersCell
        cell.configure(with: learnersViewModel, at: indexPath.row)
        cell.selectionStyle = .none
        
        cell.onDetailsTapped = { [weak self] in
            guard let self = self else { return }
            let learner = self.learnersViewModel.learner(at: indexPath.row)
            let nextViewController = LearnersDetailsViewController()
            nextViewController.learnerId = learner.learnerId
            let navigationController = UINavigationController(rootViewController: nextViewController)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
