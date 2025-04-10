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
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel = LearnerDetailsViewModel()
    var learnerId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(cancelTapped))
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        learnerImage.layer.cornerRadius = learnerImage.frame.height / 2
        learnerImage.layer.borderWidth = 0.8
        learnerImage.layer.borderColor = tenantViewModel.secondaryColor?.cgColor
        learnerImage.clipsToBounds = true
        
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
        tableView.showsVerticalScrollIndicator = false
        tableView.registerCell(cellClass: AssignCourseCell.self)
        
        fetchNotAssignedCourses()
    }
    
    private func fetchNotAssignedCourses() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        learnerImage.isHidden = true
        learnerName.isHidden = true
        
        viewModel.fetchNotAssignedCourses(learnerId: learnerId ?? 1) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.learnerImage.isHidden = false
            self.learnerName.isHidden = false
            
            switch result {
            case .success:
                self.updateUI()
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(message: "Failed to load not assigned courses: \(error.localizedDescription)", completion: {})
            }
        }
    }
    
    private func updateUI() {
        learnerName.text = viewModel.learnerName()
        if let avatarURL = viewModel.learnerImageURL(), let url = URL(string: avatarURL) {
            learnerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "User-100"))
        } else {
            learnerImage.image = UIImage(named: "User-100")
        }
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension AssignCourseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCourses()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as AssignCourseCell
        let course = viewModel.course(at: indexPath.row)
        cell.configure(category: course.category?.name ?? "UnKnown",
                       courseName: course.title,
                       instructorName: course.instructor?.name ?? "UnKnown",
                       image: course.image)
        cell.selectionStyle = .none
        
        cell.onAssignTapped = { [weak self] in
            guard let self = self, let learnerId = self.learnerId else { return }
            self.activityIndicator.startAnimating()
            self.viewModel.assignCourse(learnerId: learnerId, courseSlug: course.slug) { result in
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let message):
                    self.showSuccessAlert(message: message) {
                        self.fetchNotAssignedCourses()
                    }
                case .failure(let error):
                    self.showErrorAlert(message: "Failed to assign course: \(error.localizedDescription)", completion: {})
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
