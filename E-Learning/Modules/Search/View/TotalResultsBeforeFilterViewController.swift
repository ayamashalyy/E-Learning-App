//
//  TotalResultsBeforeFilterViewController.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import UIKit

protocol TotalResultsBeforeFilterViewControllerDelegate: AnyObject {
    func didTapFilterButton()
}

class TotalResultsBeforeFilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: SearchViewModel!
    var tableView: UITableView!
    var tenantViewModel = TenantViewModel.shared
    weak var delegate: TotalResultsBeforeFilterViewControllerDelegate?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "TotalResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalResultsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Setup Indicator
    func showLoadingIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        tableView.tableFooterView = activityIndicator
    }
    
    func hideLoadingIndicator() {
        tableView.tableFooterView = nil
    }
    
    // MARK: - Filter Button Action
    @objc func filterButtonTapped() {
        delegate?.didTapFilterButton()
    }
}
