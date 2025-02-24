//
//  User.swift
//  E-Learning
//
//  Created by Aya Mashaly on 02/02/2025.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Decodable {
    let token: String?
    let refreshToken: String?
    let message: String
    let user: User?
    let role: String?
    
    enum CodingKeys: String, CodingKey {
        case token = "token"
        case refreshToken = "refresh_token"
        case message
        case user
        case role
    }
}

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let avatar: String?
}
