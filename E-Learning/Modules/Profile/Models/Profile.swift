//
//  Profile.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/02/2025.
//

import Foundation

struct ProfileResponse: Decodable {
    let user: User
    
    struct User: Decodable {
        let name: String
        let email: String
        let avatar: String?
    }
}


