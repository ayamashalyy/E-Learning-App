//
//  ProfileViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation

class ProfileViewModel {
    private let apiService = APIService()
    var profileData: ProfileResponse?
    var onProfileDataUpdated: (() -> Void)?
    
    func fetchProfile(token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/profile"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url, token: token) { [weak self] (response: ProfileResponse?) in
            guard let self = self else { return }
            
            if let response = response {
                self.profileData = response
                self.onProfileDataUpdated?()
            } else {
                print("Failed to fetch profile data")
            }
        }
    }
}
