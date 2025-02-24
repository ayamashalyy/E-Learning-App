//
//  RefreshToken.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation

// Request Model
struct RefreshTokenRequest: Encodable {
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

// Response Model
struct RefreshTokenResponse: Decodable {
    let accessToken: String?
    let refreshToken: String?
    let message: String?
    let user: User?
    let role: String?
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "token"
        case refreshToken = "refresh_token"
        case message
        case user
        case role
    }
}
