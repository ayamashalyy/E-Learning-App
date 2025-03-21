//
//  CourseEnrollmentViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 18/03/2025.
//

import Foundation
class CourseEnrollmentViewModel {
    
    private var apiService = APIService()
    var onEnrollmentSuccess: ((String, Bool) -> Void)?
    var onEnrollmentFailure: ((String) -> Void)?
    
    func enrollInCourse(courseSlug: String, token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/course-request/\(courseSlug)/enroll"
        
        apiService.postData(to: url, data: EmptyRequest(), token: token) { [weak self] (response: CourseEnrollmentResponse?, error) in
            guard let self = self else { return }
            print("Enroll Response: \(response?.message ?? "No message"), Error: \(error?.localizedDescription ?? "No error")")
            if error != nil {
                self.onEnrollmentFailure?(response?.message ?? "Course request already sent.")
            } else if let response = response {
                self.onEnrollmentSuccess?(response.message, true)
            }
        }
    }
    
    func cancelEnrollInCourse(courseSlug: String, token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/course-request/\(courseSlug)/cancel"
        
        apiService.postData(to: url, data: EmptyRequest(), token: token) { [weak self] (response: CourseEnrollmentResponse?, error) in
            guard let self = self else { return }
            print("Cancel Response: \(response?.message ?? "No message"), Error: \(error?.localizedDescription ?? "No error")")
            if error != nil {
                self.onEnrollmentFailure?(response?.message ?? "Course cancel already sent.")
            } else if let response = response {
                self.onEnrollmentSuccess?(response.message, false)
            }
        }
    }
}
