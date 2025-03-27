//
//  TotalResultsBeforeFilterViewController+TableView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 01/03/2025.
//

import Foundation
import UIKit

extension TotalResultsBeforeFilterViewController: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalResultsTableViewCell", for: indexPath) as? TotalResultsTableViewCell else {
            return UITableViewCell()
        }
        let course = viewModel.searchResults[indexPath.row]
        
        cell.totalResultSearchCategory.text = course.category?.name
        cell.totalResultSearchNameCourse.text = course.title
        cell.totalResultSearchConstractorName.text = course.instructor?.name
        if let imageUrl = URL(string: course.image) {
            cell.totalResultSearchImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "myLearning")?.imageFlippedForRightToLeftLayoutDirection())
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Roboto-Bold", size: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        titleLabel.text = "\(viewModel.searchResults.count) \(NSLocalizedString("Total Results", comment: ""))"
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 && !viewModel.isFetchingMore {
            showLoadingIndicator()
            viewModel.loadMoreCourses { [weak self] success in
                self?.hideLoadingIndicator()
                if success {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

