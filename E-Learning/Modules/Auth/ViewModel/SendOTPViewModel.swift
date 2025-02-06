//
//  ForgetPasswordViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 03/02/2025.
//

import Foundation

class SendOTPViewModel {
    private let apiService = APIService()
    static let shared = SendOTPViewModel()
    
    private init() {}
    
    func sendOTP(to email: String, completion: @escaping (Bool, String?) -> Void) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/send-otp"
        print("Request URL: \(url)")
        
        let requestBody = ForgetPasswordRequest(email: email)
        
        apiService.postData(to: url, data: requestBody) { (response: OTPResponse?, error) in
            if let error = error {
                print(" Error sending OTP: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
                return
            }
            
            if let response = response {
                completion(true, response.message)
                print("OTP sent successfully \(response.message)")
            } else {
                completion(false, "Failed to send OTP. Please try again.")
            }
        }
    }
}
