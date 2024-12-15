//
//  QuestionModel.swift
//  E-Learning
//
//  Created by aya on 15/12/2024.
//

import Foundation

enum TypeQuestion {
    case singleChoice
    case trueFalse
    case multipleChoice
    case matching
}

struct QuestionModel {
    let title: String
    let questionDatasModel: Question
}

struct Question {
    let id: String
    let questionText: String
    var answers: [answer]
    let type: TypeQuestion
}

struct answer {
    let id: String
    let text: String
    var isSelected: Bool = false
}

struct answersParmeter {
    let questionId: String
    let answerId: String
}
