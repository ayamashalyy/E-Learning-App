//
//  TotalResultsAfterFilterViewController.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import UIKit

class TotalResultsAfterFilterViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: SearchViewModel!
    var selectedFiltersCount: Int {
        return viewModel.selectedFiltersCount
    }
    weak var delegate: TotalResultsBeforeFilterViewControllerDelegate?
    var tableView: UITableView!
    var tenantViewModel = TenantViewModel.shared
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Setup Views
    private func setupViews() {
        tableView = UITableView()
        tableView.register(UINib(nibName: "TotalResultsTableViewCell", bundle: nil), forCellReuseIdentifier: "TotalResultsTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
