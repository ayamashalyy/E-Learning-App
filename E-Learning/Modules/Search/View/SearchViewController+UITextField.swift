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
        viewModel.selectedCategoryId = nil
        viewModel.selectedInstructorId = nil
        viewModel.selectedFilters.removeAll()
        viewModel.selectedFiltersCount = 0
        
        viewModel.searchCourses(with: query) { [weak self] success in
            self?.hideLoadingIndicator()
            if success {
                self?.viewModel.currentState = .totalResultsBeforeFilter
            } else {
                self?.viewModel.currentState = .recentSearches
            }
            self?.updateUIForCurrentState()
        }
    }
    
    // MARK: - Cancel Button Action
    @objc func cancelButtonTapped() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        viewModel.currentState = viewModel.recentSearches.isEmpty ? .emptySearch : .recentSearches
        updateUIForCurrentState()
    }
    
    // MARK: - Helper Function
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        present(alert, animated: true)
    }
}
