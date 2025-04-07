//
//  LearnersDetailsViewController.swift
//  E-Learning
//
//  Created by aya on 03/01/2025.
//

import UIKit

class LearnersDetailsViewController: UIViewController {
    
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnerImage: UIImageView!
    @IBOutlet weak var learnerName: UILabel!
    @IBOutlet weak var assignCourse: UIButton!
    @IBOutlet weak var request: UIButton!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel = LearnerDetailsViewModel()
    private let requestsViewModel = LearnerRequestsViewModel()
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
        
        setupButtons()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: DetailsDataOfLearnersCell.self)
        
        fetchLearnerDetails()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchLearnerDetails()
    }
    
    private func fetchLearnerDetails() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        learnerImage.isHidden = true
        learnerName.isHidden = true
        assignCourse.isHidden = true
        request.isHidden = true
        
        viewModel.fetchLearnerDetails(learnerId: learnerId ?? 1) { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
            self.learnerImage.isHidden = false
            self.learnerName.isHidden = false
            self.assignCourse.isHidden = false
            self.request.isHidden = false
            
            switch result {
            case .success:
                self.updateUI()
                self.tableView.reloadData()
            case .failure(let error):
                self.showErrorAlert(message: "Failed to load learner details: \(error.localizedDescription)", completion: {})
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
        setupButtons()
    }
    
    func setupButtons(){
        assignCourse.setTitle("Assign Course".localized, for: .normal)
        assignCourse.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        assignCourse.setTitleColor(UIColor.white, for: .normal)
        assignCourse.setTitleColor(UIColor.white, for: .highlighted)
        assignCourse.setTitleColor(UIColor.white, for: .selected)
        assignCourse.backgroundColor = tenantViewModel.primaryColor
        assignCourse.layer.cornerRadius = 20
        
        request.setTitle(String(format: NSLocalizedString("request_count", comment: ""), viewModel.requestCount()), for: .normal)
        request.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 16)
        request.setTitleColor(UIColor.white, for: .normal)
        request.setTitleColor(UIColor.white, for: .highlighted)
        request.setTitleColor(UIColor.white, for: .selected)
        request.backgroundColor = tenantViewModel.primaryColor
        request.layer.cornerRadius = 20
        
    }
    
    @IBAction func assignCourse(_ sender: UIButton) {
        
        let nextViewController = AssignCourseViewController()
        nextViewController.learnerId = self.learnerId
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func request(_ sender: UIButton) {
        let nextViewController = NumberRequestViewController()
        nextViewController.learnerId = self.learnerId
        let navigationController = UINavigationController(rootViewController: nextViewController)
        navigationController.modalPresentationStyle = .fullScreen
        
        requestsViewModel.fetchRequests(learnerId: learnerId ?? 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if self.requestsViewModel.requestCount() == 0 {
                    self.showAlert(title: "No Requests", message: "There are no requests available for this learner.") {
                    }
                } else {
                    nextViewController.viewModel = self.requestsViewModel
                    self.present(navigationController, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showErrorAlert(message: "Failed to load requests: \(error.localizedDescription)", completion: {})
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion()
        })
        present(alert, animated: true, completion: nil)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension LearnersDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCourses()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as DetailsDataOfLearnersCell
        let course = viewModel.course(at: indexPath.row)
        cell.configure(category: course.category?.name ?? "UnKnown",
                       courseName: course.title,
                       instructorName: course.instructor?.name ?? "UnKnown",
                       progress: Float(course.progress ?? 0),
                       image: course.image)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
