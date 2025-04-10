//
//  RecentSearchesViewController.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import UIKit

protocol RecentSearchesDelegate: AnyObject {
    func didSelectRecentSearch(_ searchTerm: String)
    func didDeleteRecentSearch(at index: Int)
}

class RecentSearchesViewController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: RecentSearchesDelegate?
    var tableView: UITableView!
    var tenantViewModel = TenantViewModel.shared
    var viewModel: SearchViewModel!
    
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
        tableView.register(UINib(nibName: "RecentSearchesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
}
