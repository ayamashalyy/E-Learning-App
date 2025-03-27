//
//  QuizSubmitResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 23/03/2025.
//

import Foundation

struct QuizSubmitResponse: Decodable {
    let message: String
    let isPassed: Bool
    let score: Double
    let passPercentage: Int
    
    enum CodingKeys: String, CodingKey {
        case message
        case isPassed = "is_passed"
        case score
        case passPercentage = "pass_percentage"
    }
}
