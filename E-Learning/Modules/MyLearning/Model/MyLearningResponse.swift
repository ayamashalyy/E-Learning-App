//
//  MyLearningResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

struct LearningResponse: Decodable {
    let inProgress: [Course]
    let assigned: [Course]
    let completed: [Course]
    
    enum CodingKeys: String, CodingKey {
        case inProgress = "in_progress"
        case assigned
        case completed
    }
}

