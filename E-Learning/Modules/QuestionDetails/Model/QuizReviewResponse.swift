//
//  QuizReviewResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/03/2025.
//

import Foundation

struct QuizReviewResponse: Codable {
    let data: QuizReviewData
}

struct QuizReviewData: Codable {
    let quizScore: Int
    let learnerScore: Int
    let isPassed: Int
    let questions: [ReviewQuestion]
    
    enum CodingKeys: String, CodingKey {
        case quizScore = "quiz_score"
        case learnerScore = "learner_score"
        case isPassed = "is_passed"
        case questions
    }
}

struct ReviewQuestion: Codable {
    let title: String
    let type: String
    let points: Int
    let options: Options
    let correctAnswer: CorrectAnswer
    let answer: Answer
    let isCorrect: Int
    
    enum CodingKeys: String, CodingKey {
        case title, type, points, options
        case correctAnswer = "correct_answer"
        case answer
        case isCorrect = "is_correct"
    }
}

enum Options: Codable {
    case stringArray([String])
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([String].self) {
            self = .stringArray(array)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid options format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringArray(let array):
            try container.encode(array)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}

enum CorrectAnswer: Codable {
    case stringArray([String])
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let array = try? container.decode([String].self) {
            self = .stringArray(array)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid correct_answer format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .stringArray(let array):
            try container.encode(array)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}

enum Answer: Codable {
    case string(String)
    case stringArray([String])
    case dictionary([String: String])
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([String].self) {
            self = .stringArray(array)
        } else if let dict = try? container.decode([String: String].self) {
            self = .dictionary(dict)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid answer format")
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value):
            try container.encode(value)
        case .stringArray(let array):
            try container.encode(array)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}
