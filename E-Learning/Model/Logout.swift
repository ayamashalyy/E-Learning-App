//
//  Logout.swift
//  E-Learning
//
//  Created by Aya Mashaly on 04/02/2025.
//

import Foundation

struct LogoutRequest: Encodable {
    let email: String
    let otp: String
    let password: String
    let password_confirmation: String
}

struct LogoutResponse: Decodable {
    struct User: Decodable {
        let id: Int
        let name: String
        let email: String
        let avatar: String?
    }
    
    let user: User
}
