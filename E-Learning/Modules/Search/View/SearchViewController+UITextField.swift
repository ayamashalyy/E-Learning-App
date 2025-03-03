//
//  SearchViewController+UITextField.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation
import UIKit

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchButtonTapped()
        }
        return true
    }
    
    // MARK: - Search Button Action
    @objc func searchButtonTapped() {
        guard let query = searchTextField.text, !query.isEmpty else {
            showAlert(message: "Please enter a search term.".localized)
            return
        }
        
        //        // Reset selected filters when starting a new search
        viewModel.selectedFilters.removeAll()
        viewModel.selectedFiltersCount = 0
        
        // Add the new search query to the beginning of the recent searches list
        viewModel.addRecentSearch(query)
        recentSearchesViewController.tableView.reloadData()
        
        viewModel.searchCourses(with: query) { [weak self] success in
            if success {
                self?.viewModel.currentState = .totalResultsBeforeFilter
                self?.updateUIForCurrentState()
                self?.totalResultsBeforeFilterViewController.tableView.reloadData()
            } else {
                self?.viewModel.currentState = .recentSearches
                self?.updateUIForCurrentState()
                self?.recentSearchesViewController.tableView.reloadData()
            }
        }
        resetFilters()
    }
    
    // MARK: - Reset Filters
    func resetFilters() {
        viewModel.resetFilters()
        DispatchQueue.main.async {
            self.viewModel.currentState = .totalResultsBeforeFilter
            self.updateUIForCurrentState()
        }
    }
    
    // MARK: - Cancel Button Action
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        viewModel.currentState = .recentSearches
        updateUIForCurrentState()
    }
    
    // MARK: - Helper Function
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
