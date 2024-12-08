//
//  QuizViewModel.swift
//  E-Learning
//
//  Created by aya on 08/12/2024.
//

import Foundation

class QuizViewModel {
    
    private var questions: [QuizQuestion] = []
    private(set) var currentQuestionIndex: Int = 0
    var selectedAnswers: [Int] = []
    
    var currentQuestion: QuizQuestion {
        return questions[currentQuestionIndex]
    }
    
    func loadQuestions() {
        
        questions = [
            QuizQuestion(questionText: "How is the waterfall method different?",
                         options: ["Comprehensive documentation", "Another option", "Option 3"],
                         correctAnswers: [0],
                         questionType: .singleChoice),
            
            QuizQuestion(questionText: "How is the waterfall method different?",
                         options: ["True", "False"],
                         correctAnswers: [0],
                         questionType: .trueFalse),
            
            QuizQuestion(questionText: "How is the waterfall method different?",
                         options: ["Comprehensive documentation", "Another option", "Option 3"],
                         correctAnswers: [0,1],
                         questionType: .multipleChoice),
            
        ]
    }
    
    func moveToNextQuestion() -> Bool {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            return true
        }
        return false
    }
    
    func moveToPreviousQuestion() -> Bool {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            return true
        }
        return false
    }
}
