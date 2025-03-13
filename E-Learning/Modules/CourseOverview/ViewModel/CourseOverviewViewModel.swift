//
//  CourseOverviewViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 11/03/2025.
//

import Foundation

class CourseOverviewViewModel {
    private var apiService = APIService()
    private var course: Course?
    var onDataFetched: (() -> Void)?
    
    func fetchCourseData(courseSlug: String, token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/courses/\(courseSlug)"
        apiService.fetchData(from: url, token: token) { [weak self] ( courseResponse:  CourseDetailsResponse?, error) in
            guard let self = self else { return }
            if let courseResponse = courseResponse {
                self.course = courseResponse.data
                self.onDataFetched?()
            } else if let error = error {
                print("Error fetching course data: \(error)")
            }
        }
    }
    
    func getCourse() -> Course? {
        return course
    }
}
