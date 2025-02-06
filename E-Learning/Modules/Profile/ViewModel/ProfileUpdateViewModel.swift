//
//  ProfileUpdateViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation


class ProfileUpdateViewModel {
    
    private let apiService = APIService()
    
    func updateProfile(name: String, email: String, avatar: Data?, token: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/profile"
        print("Request URL: \(url)")
        
        let profileUpdateRequest = ProfileUpdateRequest(name: name, email: email, avatar: avatar)
        
        apiService.postUpdateProfileData(to: url, data: profileUpdateRequest, token: token) { (response: ProfileUpdateResponse?) in
            if let response = response {
                let updatedUser = response.user
                print("Profile Updated: \(updatedUser.name), \(updatedUser.email)")
                completion(.success(()))
            } else {
                completion(.failure(NSError(domain: "ProfileUpdateError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error: Failed to update profile."])))
            }
        }
    }
}
