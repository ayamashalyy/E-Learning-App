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
        
        // Reset selected filters when starting a new search
        selectedFilters.removeAll()
        selectedFiltersCount = 0
        
        // Reload the collection view to reflect the reset filters
        collectionView.reloadData()
        
        // Add the new search query to the beginning of the recent searches list
        recentSearches.insert(query, at: 0)
        // Save the updated recent searches list (e.g., to UserDefaults or a database)
        saveRecentSearches()
        
        viewModel.searchCourses(with: query) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.currentState = success ? .totalResultsBeforeFilter : .recentSearches
                    self?.tableView.reloadData()
                }
            }
        }
        updateNoRecentSearchImage()
        resetFilters()
    }
    
    // MARK: - Reset Filters
    func resetFilters() {
        viewModel.resetFilters()
        DispatchQueue.main.async {
            self.currentState = .totalResultsBeforeFilter
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Cancel Button Action
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        currentState = .recentSearches
        tableView.isHidden = false
        filterContainerView.isHidden = true
        tableView.reloadData()
        updateNoRecentSearchImage()
    }
    
    // MARK: - Helper Function
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
