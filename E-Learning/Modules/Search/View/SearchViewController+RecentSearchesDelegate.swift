//
//  SearchViewController+RecentSearchesDelegate.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation

extension SearchViewController: RecentSearchesDelegate {
    
    func didSelectRecentSearch(_ searchTerm: String) {
        searchTextField.text = searchTerm
    }
    
    func didDeleteRecentSearch(at index: Int) {
        viewModel.deleteRecentSearch(at: index)
        recentSearchesViewController.tableView.reloadData()
    }
}


