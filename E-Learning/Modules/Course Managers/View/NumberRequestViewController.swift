//
//  NumberRequestViewController.swift
//  E-Learning
//
//  Created by aya on 04/01/2025.
//

import UIKit

class NumberRequestViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var learnerImage: UIImageView!
    @IBOutlet weak var learnerName: UILabel!
    var tenantViewModel = TenantViewModel.shared
    var backButtonImage: UIImage!
    var learnerId: Int?
    var viewModel: LearnerRequestsViewModel?
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: NumberRequestCell.self)
        
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updateUI()
    }
    
    private func updateUI() {
        if let request = viewModel?.request(at: 0) {
            learnerName.text = request.learner.name
            if let avatarURL = request.learner.avatar, let url = URL(string: avatarURL) {
                learnerImage.sd_setImage(with: url, placeholderImage: UIImage(named: "User-100"))
            } else {
                learnerImage.image = UIImage(named: "User-100")
            }
        }
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension NumberRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.requestCount() ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(indexPath: indexPath) as NumberRequestCell
        if let request = viewModel?.request(at: indexPath.row) {
            cell.configure(category: request.course.category?.name ?? "Unknown",
                           courseName: request.course.title,
                           instructorName: request.course.instructor?.name ?? "Unknown",
                           image: request.course.image)
        }
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}


extension NumberRequestViewController: NumberRequestCellDelegate {
    func didTapApproveButton(on cell: NumberRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let request = viewModel?.request(at: indexPath.row) else { return }
        
        activityIndicator.startAnimating()
        viewModel?.updateRequestStatus(requestId: request.id, status: "approved") { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let message):
                self.showSuccessAlert(message: message) {
                    self.viewModel?.fetchRequests(learnerId: self.learnerId ?? 1) { result in
                        switch result {
                        case .success:
                            self.tableView.reloadData()
                        case .failure(let error):
                            self.showErrorAlert(message: "Failed to refresh requests: \(error.localizedDescription)", completion: {})
                        }
                    }
                }
            case .failure(let error):
                self.showErrorAlert(message: "Failed to approve request: \(error.localizedDescription)", completion: {})
            }
        }
    }
    
    func didTapRejectButton(on cell: NumberRequestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
              let request = viewModel?.request(at: indexPath.row) else { return }
        
        activityIndicator.startAnimating()
        viewModel?.updateRequestStatus(requestId: request.id, status: "rejected") { [weak self] result in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let message):
                self.showSuccessAlert(message: message) {
                    self.viewModel?.fetchRequests(learnerId: self.learnerId ?? 1) { result in
                        switch result {
                        case .success:
                            self.tableView.reloadData()
                        case .failure(let error):
                            self.showErrorAlert(message: "Failed to refresh requests: \(error.localizedDescription)", completion: {})
                        }
                    }
                }
            case .failure(let error):
                self.showErrorAlert(message: "Failed to reject request: \(error.localizedDescription)", completion: {})
            }
        }
    }
}
