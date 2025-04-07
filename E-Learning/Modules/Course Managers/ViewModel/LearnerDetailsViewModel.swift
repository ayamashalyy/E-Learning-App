//
//  LearnerDetailsViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/04/2025.
//

import Foundation

class LearnerDetailsViewModel {
    private var learnerDetailsResponse: LearnerDetailsResponse?
    private let apiService = APIService()
    private var learner: LearnerDetails?
    private var courses: [CourseDetails] = []
    
    
    func requestCount() -> Int {
        return learnerDetailsResponse?.requestsCount ?? 0
    }
    
    func learnerName() -> String? {
        return learner?.name
    }
    
    func learnerImageURL() -> String? {
        return learner?.avatar
    }
    
    func numberOfCourses() -> Int {
        return courses.count
    }
    
    func course(at index: Int) -> CourseDetails {
        return courses[index]
    }
    
    func fetchLearnerDetails(learnerId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/learners/\(learnerId)"
        print("Request URL: \(url)")
        
        guard let token = UserSessionManager.shared.token else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
            return
        }
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: LearnerDetailsResponse?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch learner details: \(error)")
                completion(.failure(error))
            } else if let response = response {
                print("API Response requestsCount: \(String(describing: response.requestsCount))")
                self.learnerDetailsResponse = response
                self.learner = response.learner
                self.courses = response.courses
                print("Successfully fetched learner details for \(self.learner?.name ?? "unknown") with \(self.courses.count) courses")
                completion(.success(()))
            }
        }
    }
    
    func fetchNotAssignedCourses(learnerId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/learners/\(learnerId)/not-assign-course"
        print("Request URL: \(url)")
        
        guard let token = UserSessionManager.shared.token else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
            return
        }
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: LearnerDetailsResponse?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch not assigned courses: \(error)")
                completion(.failure(error))
            } else if let response = response {
                self.learner = response.learner
                self.courses = response.courses
                print("Successfully fetched not assigned courses for \(self.learner?.name ?? "unknown") with \(self.courses.count) courses")
                completion(.success(()))
            }
        }
    }
    
    func assignCourse(learnerId: Int, courseSlug: String, completion: @escaping (Result<String, Error>) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/learners/\(learnerId)/assign-course/\(courseSlug)"
        guard let token = UserSessionManager.shared.token else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
            return
        }
        
        apiService.postData(to: url, data: EmptyRequest(), token: token) { (response: AssignCourseResponse?, error: Error?) in
            if let error = error {
                completion(.failure(error))
            } else if let response = response {
                completion(.success(response.message))
            }
        }
    }
}
