//
//  ResetPassword.swift
//  E-Learning
//
//  Created by Aya Mashaly on 04/02/2025.
//

import Foundation

struct ResetPasswordRequest: Codable {
    let email: String
    let otp: String
    let password: String
    let passwordConfirmation: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case otp
        case password
        case passwordConfirmation = "password_confirmation"
    }
}

struct ResetPasswordResponse: Codable {
    let message: String
}
