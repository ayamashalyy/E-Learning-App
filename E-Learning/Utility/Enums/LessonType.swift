//
//  LessonType.swift
//  E-Learning
//
//  Created by Aya Mashaly on 24/03/2025.
//

import Foundation

enum LessonType: String {
    case video = "video"
    case text = "text"
    case audio = "audio"
    case document = "document"
    case scorm = "scorm"
    case aicc = "aicc"
    case quiz = "quiz"
    case unknown = "unknown"
    
    init(rawValue: String) {
        switch rawValue {
        case "video": self = .video
        case "text": self = .text
        case "audio": self = .audio
        case "document": self = .document
        case "scorm": self = .scorm
        case "aicc": self = .aicc
        case "quiz": self = .quiz
        default: self = .unknown
        }
    }
}
