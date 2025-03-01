//
//  SearchViewController+TableView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation
import UIKit

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch currentState {
        case .recentSearches:
            return recentSearches.count
        case .totalResultsBeforeFilter:
            return viewModel.searchResults.count
        case .totalResultsAfterFilter:
            return viewModel.filteredResults.count
        case .filterView:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentState == .recentSearches {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RecentSearchesTableViewCell else {
                return UITableViewCell()
            }
            cell.recentSearchLabel.text = recentSearches[indexPath.row]
            cell.selectionStyle = .none
            cell.onCancelTapped = { [weak self] in
                self?.recentSearches.remove(at: indexPath.row)
                self?.saveRecentSearches()
                self?.updateNoRecentSearchImage()
                tableView.reloadData()
            }
            return cell
        }
        else if currentState == .totalResultsBeforeFilter {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            let course = viewModel.searchResults[indexPath.row]
            
            cell.totalResultSearchCategory.text = course.category.name
            cell.totalResultSearchNameCourse.text = course.title
            cell.totalResultSearchConstractorName.text =  course.instructor.name
            if let imageUrl = URL(string: course.image) {
                cell.totalResultSearchImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection())
            }
            cell.selectionStyle = .none
            return cell
        } else if currentState == .totalResultsAfterFilter {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
                return UITableViewCell()
            }
            let course = viewModel.filteredResults[indexPath.row]
            
            cell.totalResultSearchCategory.text = course.category.name
            cell.totalResultSearchNameCourse.text = course.title
            cell.totalResultSearchConstractorName.text = course.instructor.name
            if let imageUrl = URL(string: course.image) {
                cell.totalResultSearchImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection())
            }
            cell.selectionStyle = .none
            return cell
            
        } else {
        }
        return UITableViewCell()
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if recentSearches.isEmpty && currentState == .recentSearches {
            return nil
        }
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        
        
        if currentState == .recentSearches {
            titleLabel.text = "Recent Searches".localized
            titleLabel.textColor = tenantViewModel.primaryColor
        } else if currentState == .totalResultsBeforeFilter {
            titleLabel.text = "\(viewModel.searchResults.count) \(NSLocalizedString("Total Results", comment: ""))"
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        if currentState == .totalResultsBeforeFilter {
            let filterButton = UIButton(type: .system)
            filterButton.setImage(UIImage(named: "ion_filter")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            filterButton.tintColor = tenantViewModel.primaryColor
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filterButton)
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                filterButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10)
            ])
        } else if currentState == .totalResultsAfterFilter {
            let resultsCountLabel = UILabel()
            resultsCountLabel.text = "\(viewModel.filteredResults.count)".localized
            resultsCountLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            resultsCountLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(resultsCountLabel)
            
            let resultsTextLabel = UILabel()
            resultsTextLabel.text = "Total Results".localized
            resultsTextLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            resultsTextLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(resultsTextLabel)
            
            let filtersLabel = UILabel()
            filtersLabel.text = "(\(selectedFiltersCount ?? 0) \(NSLocalizedString("Filters", comment: "")))"
            filtersLabel.font = UIFont(name: "Roboto-Medium", size: 16)
            filtersLabel.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filtersLabel)
            
            let filterButton = UIButton(type: .system)
            filterButton.setImage(UIImage(named: "icon_filter-remove")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
            filterButton.tintColor = tenantViewModel.primaryColor
            filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
            filterButton.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(filterButton)
            
            NSLayoutConstraint.activate([
                resultsCountLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                resultsCountLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                resultsTextLabel.leadingAnchor.constraint(equalTo: resultsCountLabel.trailingAnchor, constant: 5),
                resultsTextLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                filtersLabel.leadingAnchor.constraint(equalTo: resultsTextLabel.trailingAnchor, constant: 5),
                filtersLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
                
                filterButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
                filterButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
            
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
                titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
            ])
        }
        
        return headerView
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = tenantViewModel.primaryColor
            header.textLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSearch = recentSearches[indexPath.row]
        searchTextField.text = selectedSearch
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if currentState == .totalResultsBeforeFilter {
            return 120
        } else if currentState == .recentSearches {
            return 50
        } else if currentState == .totalResultsAfterFilter {
            return 120
        }
        return 0
    }
}
