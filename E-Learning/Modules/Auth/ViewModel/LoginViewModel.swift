//
//  LoginViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 02/02/2025.
//

import Foundation

class LoginViewModel {
    var email: String = ""
    var password: String = ""
    private let apiService = APIService()
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func login(completion: @escaping (LoginResponse?) -> Void) {
        
        guard isValidEmail(email), isValidPassword(password) else {
            print("Invalid email format or password must be at least 8 characters long")
            completion(nil)
            return
        }
        
        let loginRequest = LoginRequest(email: email, password: password)
        print("Login Request: \(loginRequest)")
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/auth/login"
        print("Request URL: \(url)")
        
        apiService.postData(to: url, data: loginRequest) { (response: LoginResponse?) in
            if let response = response {
                print("\(response)")
                completion(response)
            } else {
                print("Login failed or invalid response")
            }
        }
    }
}
