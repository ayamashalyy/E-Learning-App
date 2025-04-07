//
//  learners.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/04/2025.
//

import Foundation

struct LearnersResponse: Decodable {
    let learners: [Learner]
}

struct Learner: Decodable {
    let learnerId: Int
    let name: String
    let email: String
    let avatar: String?
    let courseCount: Int
    
    enum CodingKeys: String, CodingKey {
        case learnerId = "learner_id"
        case name
        case email
        case avatar
        case courseCount = "course_count"
    }
}
