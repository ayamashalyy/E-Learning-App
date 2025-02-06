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
    let message: String
    let user: User?
    let role: String?
}

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
    let avatar: String?
}
