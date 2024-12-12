//
//  QuizQuestion.swift
//  E-Learning
//
//  Created by aya on 08/12/2024.
//

import Foundation

struct MatchingOption {
    let leftOption: String
    let rightOption: String
}

struct QuizQuestion {
    var questionText: String
    var options: [String]?
    var matchingPairs: [MatchingOption]?
    var correctAnswers: [Int]
    var questionType: QuestionType
}

enum QuestionType {
    case singleChoice
    case trueFalse
    case multipleChoice
    case matching
}
