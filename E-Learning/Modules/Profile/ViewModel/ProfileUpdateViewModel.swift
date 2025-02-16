//
//  ProfileUpdateViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation
import Alamofire


class ProfileUpdateViewModel {
    
    func updateProfile(name: String, email: String, avatar: Data?, password: String, password_confirmation: String, token: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/profile"
        
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password,
            "password_confirmation": password_confirmation
        ]
        
        let boundary = UUID().uuidString
        var headers: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "multipart/form-data; boundary=\(boundary)",
        ]
        
        headers["Authorization"] = "Bearer \(token)"
        
        AF.upload(multipartFormData: { multipartFormData in
            // Append the file with the key "Avatar"
            if let avatar = avatar {
                multipartFormData.append(avatar, withName: "avatar", fileName: "avatar.jpg", mimeType: "image/jpeg")
            } else {
                print("No avatar data found")
            }
            
            // Append text parameters
            for (key, value) in parameters {
                if let data = value.data(using: .utf8) {
                    multipartFormData.append(data, withName: key)
                }
            }
            
            
            print("Request Headers: \(headers)")
            print("Request Body contains: \(parameters)")
            if let avatar = avatar {
                print("Request Body contains an image of size: \(avatar.count) bytes")
            } else {
                print("No avatar data included")
            }
            
        }, to: url, method: .post, headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success(let data):
                print("Profile updated successfully: \(String(describing: data))")
                completion(.success(data))
            case .failure(let error):
                print("Failed to update profile: \(error.localizedDescription)")
                if let data = response.data, let errorMessage = String(data: data, encoding: .utf8) {
                    print("Server Response: \(errorMessage)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
}
