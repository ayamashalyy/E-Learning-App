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
    let id: Int
    let title: String
    let type: String
    let points: Int
    let options: [String]?
    let correctAnswer: [String]?
    let answer: [String]?
    let isCorrect: Bool
    let correctLeft: [String]?
    let correctRight: [String]?
    let answerLeft: [String]?
    let answerRight: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, type, points, options
        case correctAnswer = "correct_answer"
        case answer
        case isCorrect = "is_correct"
        case correctLeft = "correct_left"
        case correctRight = "correct_right"
        case answerLeft = "answer_left"
        case answerRight = "answer_right"
    }
    
    var isMatchingType: Bool {
        return type.lowercased() == "matching"
    }
    
    var leftOptions: [String]? {
        return isMatchingType ? answerLeft : options
    }
    
    var rightOptions: [String]? {
        return isMatchingType ? answerRight : nil
    }
    
    var correctLeftOptions: [String]? {
        return isMatchingType ? correctLeft : nil
    }
    
    var correctRightOptions: [String]? {
        return isMatchingType ? correctRight : nil
    }
}
