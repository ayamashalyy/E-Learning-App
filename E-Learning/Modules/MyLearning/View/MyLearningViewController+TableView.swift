//
//  MyLearningViewController+TableView.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation
import UIKit

extension MyLearningViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mySegmentedControl.selectedSegmentIndex {
        case 0: return viewModel.inProgressCourses.count
        case 1: return viewModel.assignedCourses.count
        case 2: return viewModel.completedCourses.count
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyLearningTableViewCell", for: indexPath) as? MyLearningTableViewCell else {
            fatalError("Unable to dequeue MyLearningTableViewCell")
        }
        let cellViewModel = viewModel.getCellViewModel(for: indexPath, segmentIndex: mySegmentedControl.selectedSegmentIndex)
        cell.configure(with: cellViewModel)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    // MARK: - UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
