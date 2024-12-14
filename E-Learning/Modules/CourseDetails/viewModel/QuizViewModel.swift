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
    var selectedOptionIndex: Int? = nil
    
    var currentQuestion: QuizQuestion {
        guard currentQuestionIndex >= 0 && currentQuestionIndex < questions.count else {
            fatalError("currentQuestionIndex out of bounds!")
        }
        return questions[currentQuestionIndex]
    }
    
    
    var totalQuestions: Int {
        return questions.count
    }
    
    
    func loadQuestions() {
        
        questions = [
            QuizQuestion(questionText: "How is the waterfall method different?",
                         options: ["Comprehensive documentation", "Another option", "Option 3"],
                         correctAnswers: [0],
                         questionType: .singleChoice),
            
            QuizQuestion(questionText: "True or False?",
                         options: ["True", "False"],
                         correctAnswers: [0],
                         questionType: .trueFalse),
            
            QuizQuestion(questionText: "Choose multiple options",
                         options: ["Option A", "Option B", "Option C"],
                         correctAnswers: [0, 1, 2],
                         questionType: .multipleChoice),
            
            QuizQuestion(questionText: "Match the following:",
                         options: ["Apple","Microsoft","Google","iPhone","Windows","Android"],
                         correctAnswers: [0, 1, 2],
                         questionType: .matching)
            
        ]
        selectedOptionIndex = nil
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
    
    var correctAnswersCount: Int {
        return questions.filter { $0.isCorrect }.count
    }
    
    var score: Int {
        return (correctAnswersCount * 100) / totalQuestions
    }
    
    func updateSelectedAnswers(_ answers: [Int]) {
        questions[currentQuestionIndex].selectedAnswers = answers
    }
    
}
