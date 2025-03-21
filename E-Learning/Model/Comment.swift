//
//  Comment.swift
//  E-Learning
//
//  Created by Aya Mashaly on 11/03/2025.
//

import Foundation

struct Comment: Decodable {
    let id: Int
    let comment: String
    let user: User
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, comment, user
        case createdAt = "created_at"
    }
}

struct CommentResponse: Decodable {
    let message: String
}
