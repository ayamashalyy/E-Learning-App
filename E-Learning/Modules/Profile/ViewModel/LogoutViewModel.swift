//
//  LogoutViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 04/02/2025.
//

import Foundation

enum LogoutError: Error {
    case unknownError(String)
}

class LogoutViewModel {
    private let apiService = APIService()
    
    func postLogout(token: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/logout"
        print("Request URL: \(url)")
        
        apiService.postData(to: url, data: EmptyRequest(), token: token) { (response: LogoutResponse?, error) in
            if let error = error {
                print("Logout error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            if let response = response {
                completion(.success(response.message))
            } else {
                completion(.failure(LogoutError.unknownError("Unknown logout error")))
            }
        }
    }
}
