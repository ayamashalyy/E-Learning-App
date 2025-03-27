//
//  LessonType.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/03/2025.
//

import Foundation

enum LessonType: String {
    case text = "TEXT"
    case video = "VIDEO"
    case audio = "AUDIO"
    case document = "DOCUMENT"
    case scorm = "SCORM"
    case aicc = "AICC"
    case quiz = "QUIZ"
    case unknown
    
    init(rawValue: String) {
        switch rawValue {
        case "TEXT": self = .text
        case "VIDEO": self = .video
        case "AUDIO": self = .audio
        case "DOCUMENT": self = .document
        case "SCORM": self = .scorm
        case "AICC": self = .aicc
        case "QUIZ": self = .quiz
        default: self = .unknown
        }
    }
}
