//
//  LogoutViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 04/02/2025.
//

import Foundation

class LogoutViewModel {
    private let apiService = APIService()
    
    func postLogout(email: String, otp: String, password: String, passwordConfirmation: String, token: String, completion: @escaping (LogoutResponse?) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/logout"
        print("Request URL: \(url)")
        let requestData = LogoutRequest(email: email, otp: otp, password: password, password_confirmation: passwordConfirmation)
        
        apiService.postData(to: url, data: requestData, token: token) { (response: LogoutResponse?, error) in
            if let error = error {
                print("Logout error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(response)
        }
    }
}
