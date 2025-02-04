//
//   ResetPasswordViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 03/02/2025.
//

import Foundation

class  VerifyOTPViewModel {
    
    private let apiService = APIService()
    var email: String
    var otp: String
    var isOTPValid: Bool = false
    
    init(email: String, otp: String) {
        self.email = email
        self.otp = otp
    }
    
    func verifyOTP(completion: @escaping (String?) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/verify-otp"
        print("Request URL: \(url)")
        let otpRequest = OTPRequest(email: self.email, otp: self.otp)
        
        apiService.postData(to: url, data: otpRequest) { (response: OTPResponse?) in
            if let response = response {
                if response.message == "Invalid OTP" {
                    completion("Invalid OTP. Please try again.")
                } else {
                    completion(nil)
                }
            } else {
                completion("An error occurred. Please try again.")
            }
        }
    }
}
