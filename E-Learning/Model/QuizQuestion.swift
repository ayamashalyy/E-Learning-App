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
    var selectedAnswers: [Int] = []
    var questionType: QuestionType
    
    var isCorrect: Bool {
           return correctAnswers.sorted() == selectedAnswers.sorted()
       }
}

enum QuestionType {
    case singleChoice
    case trueFalse
    case multipleChoice
    case matching
}
