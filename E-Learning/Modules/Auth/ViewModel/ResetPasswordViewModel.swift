//
//  ResetPasswordViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 04/02/2025.
//

import Foundation

class ResetPasswordViewModel {
    var apiService = APIService()
    
    func resetPassword(email: String, otp: String, password: String, passwordConfirmation: String, completion: @escaping (String?) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/reset-password"
        print("Request URL: \(url)")
        
        let request = ResetPasswordRequest(email: email, otp: otp, password: password, passwordConfirmation: passwordConfirmation)
        print("\(request)")
        
        apiService.postData(to: url, data: request) { (response: ResetPasswordResponse?, error) in
            if let error = error {
                print(" Error: \(error.localizedDescription)")
                completion("An error occurred. Please try again.")
                return
            }
            
            if let response = response {
                UserSessionManager.shared.newPassword = password
                UserSessionManager.shared.confirmPassword = passwordConfirmation
                completion(response.message)
                print("response\(response)")
                print("response\(response.message)")
            } else {
                completion(nil)
            }
        }
    }
    
    func validatePasswords(password: String, confirmPassword: String) -> Bool {
        if password.count < 8 {
            return false
        }
        return password == confirmPassword
    }
}
