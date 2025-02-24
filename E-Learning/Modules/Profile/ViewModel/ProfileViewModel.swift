//
//  ProfileViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation

class ProfileViewModel {
    private let apiService = APIService()
    var tenantViewModel = TenantViewModel.shared
    var name: String?
    var email: String?
    var avatar: String?
    
    func fetchProfile(token: String, completion: @escaping (Result<ProfileResponse, Error>) -> Void) {
        guard let subDomain = tenantViewModel.urlTenant, !subDomain.isEmpty else {
            print("Subdomain is missing or invalid: \(tenantViewModel.urlTenant ?? "No subdomain")")
            return
        }
        print("subDomainGetProfile: \(subDomain)")
        
        let url = "\(subDomain)/profile"
        print("Request URL GetProfile: \(url)")
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: ProfileResponse?, error: Error?) in
            guard let self = self else { return }
            
            if let response = response {
                print("Response: \(response)")
                self.name = response.user.name
                self.email = response.user.email
                self.avatar = response.user.avatar
                
                completion(.success(response))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
