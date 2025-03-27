//
//  ProgressCourseViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 22/03/2025.
//

import Foundation

class ProgressCourseViewModel {
    
    private let apiService = APIService()
    var onProgressUpdated: ((String?) -> Void)?
    var onHomeDataRefreshNeeded: (() -> Void)?
    
    func updateCourseProgress(courseSlug: String, lessonId: Int, token: String) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/course/\(courseSlug)/progress"
        
        let requestData = CourseProgressRequest(lesson_id: lessonId)
        
        apiService.postData(to: url, data: requestData, token: token) { [weak self] (response: CourseProgressResponse?, error) in
            if let response = response {
                print("Success: \(response.message)")
                self?.onProgressUpdated?(response.message)
                self?.onHomeDataRefreshNeeded?()
            }
            else if let error = error {
                print("Failure: \(error.localizedDescription)")
                self?.onProgressUpdated?("Failed to update progress")
            }
        }
    }
}

struct CourseProgressRequest: Encodable {
    let lesson_id: Int
}

struct CourseProgressResponse: Decodable {
    let message: String
}
