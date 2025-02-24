//
//  LoginViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 02/02/2025.
//

import Foundation
import Alamofire

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
        
        apiService.postData(to: url, data: loginRequest) { (response: LoginResponse?, error) in
            if let error = error {
                if let afError = error as? AFError {
                    switch afError {
                    case .responseValidationFailed(let reason):
                        if case .unacceptableStatusCode(let code) = reason, code == 401 {
                            print("Login failed: Invalid credentials")
                            completion(LoginResponse(token: nil, refreshToken: nil, message: "Invalid credentials", user: nil, role: nil))
                            
                            return
                        }
                    default:
                        break
                    }
                }
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let response = response {
                if let token = response.token, let refreshToken = response.refreshToken  {
                    print("Received response: \(response)")
                    UserSessionManager.shared.token = token
                    UserSessionManager.shared.refreshToken = refreshToken
                    UserSessionManager.shared.saveUserCredentialsToUserDefaults()
                    UserSessionManager.shared.email = response.user?.email
                    UserSessionManager.shared.name = response.user?.name
                    completion(response)
                } else {
                    print("Login failed: \(response.message)")
                    completion(nil)
                }
            } else {
                print("Login failed: Invalid response from server")
                completion(nil)
            }
        }
    }
}
