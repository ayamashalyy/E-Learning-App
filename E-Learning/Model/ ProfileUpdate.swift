//
//   ProfileUpdate.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation

struct ProfileUpdateResponse: Decodable {
    let user: Profile
}

struct Profile: Decodable {
    let id: Int
    let name: String
    let email: String
    let avatar: Data?
}

struct ProfileUpdateRequest: Encodable {
    let name: String
    let email: String
    let avatar: Data?
    let password: String
    let password_confirmation: String
}

