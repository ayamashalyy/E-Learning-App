//
//  LearnersViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/04/2025.
//

import Foundation

class LearnersViewModel {
    private let apiService = APIService()
    private var learners: [Learner] = []
    
    
    func numberOfLearners() -> Int {
        learners.count
    }
    
    func learner(at index: Int) -> Learner {
        return learners[index]
    }
    
    func fetchLearners(completion: @escaping (Result<Void, Error>) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/learners"
        print("Request URL: \(url)")
        
        guard let token = UserSessionManager.shared.token else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
            return
        }
        
        apiService.fetchData(from: url, token: token) { (response: LearnersResponse?, error: Error?) in
            if let error = error {
                print("Failed to fetch learners: \(error)")
                completion(.failure(error))
            } else if let response = response {
                self.learners = response.learners
                print("Successfully fetched \(self.learners.count) learners")
                completion(.success(()))
            }
        }
    }
}
