//
//  QuizQuestion.swift
//  E-Learning
//
//  Created by aya on 08/12/2024.
//

import Foundation

struct QuizQuestion {
    var questionText: String
    var options: [String]
    var correctAnswers: [Int]
    var questionType: QuestionType
}

enum QuestionType {
    case singleChoice
    case trueFalse
    case multipleChoice
    case matching
}
