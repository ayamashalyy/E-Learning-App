//
//  LearningViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

class LearningViewModel {
    
    var inProgressCourses: [Course] = []
    var assignedCourses: [Course] = []
    var completedCourses: [Course] = []
    var errorMessage: String?
    private let apiService = APIService()
    var onDataUpdated: (() -> Void)?
    
    
    func fetchMyLearning(token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/my-learning"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: LearningResponse?, error) in
            guard let self = self else { return }
            
            if let response = response {
                inProgressCourses = response.inProgress
                assignedCourses = response.assigned
                completedCourses = response.completed
            } else if let error = error {
                errorMessage = error.localizedDescription
            }
            
            DispatchQueue.main.async {
                self.onDataUpdated?()
            }
        }
    }
    
    func getCellViewModel(for indexPath: IndexPath, segmentIndex: Int) -> MyLearningCellViewModel {
        switch segmentIndex {
        case 0:
            let course = inProgressCourses[indexPath.row]
            return MyLearningCellViewModel(course: course, state: .inProgress)
        case 1:
            let course = assignedCourses[indexPath.row]
            return MyLearningCellViewModel(course: course, state: .assigned)
        case 2:
            let completedCourse = completedCourses[indexPath.row]
            return MyLearningCellViewModel(completedCourse: completedCourse)
        default:
            fatalError("Invalid segment index")
        }
    }
}


