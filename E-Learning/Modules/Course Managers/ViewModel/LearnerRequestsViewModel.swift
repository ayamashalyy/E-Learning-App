//
//  LearnerRequestsViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 07/04/2025.
//

import Foundation

class LearnerRequestsViewModel {
    
    private let apiService = APIService()
    private var requests: [RequestDetails] = []
    private var learner: LearnerDetails?
    
    func requestCount() -> Int {
        return requests.count
    }
    
    func request(at index: Int) -> RequestDetails {
        return requests[index]
    }
    
    func fetchRequests(learnerId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/requests/\(learnerId)"
        print("Request URL: \(url)")
        
        guard let token = UserSessionManager.shared.token else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
            return
        }
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: RequestsResponse?, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                print("Failed to fetch requests: \(error)")
                completion(.failure(error))
            } else if let response = response {
                self.requests = response.data
                if let firstRequest = response.data.first {
                    self.learner = firstRequest.learner
                }
                print("Successfully fetched \(self.requests.count) requests for learner \(self.learner?.name ?? "unknown")")
                completion(.success(()))
            }
        }
    }
    
    func updateRequestStatus(requestId: Int, status: String, completion: @escaping (Result<String, Error>) -> Void) {
            let subDomain = TenantViewModel.shared.urlTenant ?? ""
            let url = "\(subDomain)/requests/\(requestId)/status"
            print("Update Status URL: \(url)")
            
            guard let token = UserSessionManager.shared.token else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No authentication token available"])))
                return
            }
            
            let body = UpdateRequestStatusBody(status: status)
            apiService.postData(to: url, data: body, token: token) { (response: UpdateRequestStatusResponse?, error: Error?) in
                if let error = error {
                    print("Failed to update request status: \(error)")
                    completion(.failure(error))
                } else if let response = response {
                    if response.exception != nil {
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: response.message])
                        completion(.failure(error))
                    } else {
                        print("Successfully updated request status: \(response.message)")
                        completion(.success(response.message))
                    }
                }
            }
        }
}
