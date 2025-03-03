//
//  SearchViewController+TotalResultsBeforeFilterViewControllerDelegate.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation
import UIKit

extension SearchViewController: TotalResultsBeforeFilterViewControllerDelegate, FilterItemsViewControllerDelegate{
    
    func didTapFilterButton() {
        viewModel.currentState = .filterView
        updateUIForCurrentState()
        
        self.title = "Filtration".localized
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search".localized
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? .boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        backButtonImage = UIImage(named: "Icon 1")?.imageFlippedForRightToLeftLayoutDirection()
        
        if let backButtonImage = backButtonImage {
            let tintedImage = backButtonImage.withTintColor(tenantViewModel.primaryColor ?? .blue, renderingMode: .alwaysOriginal)
            let backButton = UIBarButtonItem(image: tintedImage, style: .plain, target: self, action: #selector(didTapApplyButton))
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc func didTapApplyButton() {
        
        // Handle the apply button tap action
        viewModel.selectedFilters = filterViewController.selectedFilters
        viewModel.selectedFiltersCount = filterViewController.selectedFiltersCount
        // Apply filters and handle the result
        viewModel.applyFilters(selectedFilters: viewModel.selectedFilters, term: searchTextField.text) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.viewModel.currentState = .totalResultsAfterFilter
                    self?.updateUIForCurrentState()
                }
            }
        }
        
        self.title = "Search".localized
        if let tabBarItem = self.tabBarController?.tabBar.items?[self.tabBarController?.selectedIndex ?? 0] {
            tabBarItem.title = "Search".localized
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Roboto-Bold", size: 20) ?? .boldSystemFont(ofSize: 20),
            .foregroundColor: UIColor.black
        ]
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
        
        self.navigationItem.leftBarButtonItem = nil
    }
}
