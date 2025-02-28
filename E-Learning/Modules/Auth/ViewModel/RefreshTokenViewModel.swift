//
//  RefreshTokenViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation

class RefreshTokenViewModel {
    private let apiService = APIService()
    
    func refreshToken(refreshToken: String, completion: @escaping (Result<RefreshTokenResponse, Error>) -> Void) {
        print("check_request - refresh_token_request")
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/refresh"
        print("check_request - refresh_token_request: \(url)")
        let request = RefreshTokenRequest(refreshToken: refreshToken)
        apiService.postData(to: url, data: request) { (response: RefreshTokenResponse?, error) in
            if let error = error {
                completion(.failure(error))
                print("check_request - refresh_token_request_failure: \(error)")
                return
            }
            
            if let response = response {
                print("check_request - refresh_token_request_success: \(response)")
                completion(.success(response))
                
            } else {
                print("check_request - refresh_token_request_success: refreshTokenError")
                let error = NSError(domain: "RefreshTokenError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])
                completion(.failure(error))
            }
        }
    }
}
