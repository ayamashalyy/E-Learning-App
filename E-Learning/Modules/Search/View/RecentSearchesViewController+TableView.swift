//
//  RecentSearchesViewController+TableView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation
import UIKit

protocol recentSearchDelegate: AnyObject {
    func delete(index: Int)
}

extension RecentSearchesViewController: UITableViewDataSource, UITableViewDelegate, recentSearchDelegate {
    func delete(index: Int) {
        self.viewModel.deleteRecentSearch(at: index)
        print("index: \(index)")
    }
    
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recentSearches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentSearchesTableViewCell else {
            return UITableViewCell()
        }
        cell.recentSearchLabel.text = viewModel.recentSearches[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.cancelButton.tag = indexPath.row
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if viewModel.recentSearches.isEmpty {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "Recent Searches".localized
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        titleLabel.textColor = tenantViewModel.primaryColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = tenantViewModel.primaryColor
            header.textLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = viewModel.recentSearches[indexPath.row]
        delegate?.didSelectRecentSearch(selectedSearch)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
