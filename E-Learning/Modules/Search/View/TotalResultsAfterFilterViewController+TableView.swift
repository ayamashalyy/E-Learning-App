//
//  TotalResultsAfterFilterViewController+TableView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation
import UIKit

extension TotalResultsAfterFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
            return UITableViewCell()
        }
        let course = viewModel.filteredResults[indexPath.row]
        
        cell.totalResultSearchCategory.text = course.category.name
        cell.totalResultSearchNameCourse.text = course.title
        cell.totalResultSearchConstractorName.text = course.instructor?.name
        if let imageUrl = URL(string: course.image) {
            cell.totalResultSearchImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection())
        }
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        
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
        filtersLabel.text = "(\(selectedFiltersCount) \(NSLocalizedString("Filters", comment: "")))"
        filtersLabel.font = UIFont(name: "Roboto-Medium", size: 16)
        filtersLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(filtersLabel)
        
        filterButton.setImage(UIImage(named: "icon_filter-remove")?.imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        filterButton.tintColor = TenantViewModel.shared.primaryColor
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
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = tenantViewModel.primaryColor
            header.textLabel?.font = UIFont(name: "Roboto-Bold", size: 14)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    // MARK: - Filter Button Action
    @objc func filterButtonTapped() {
        delegate?.didTapFilterButton()
    }
}
