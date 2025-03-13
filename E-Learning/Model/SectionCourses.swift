//
//  Section.swift
//  E-Learning
//
//  Created by Aya Mashaly on 11/03/2025.
//

import Foundation

struct SectionCourses: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let lessons: [Lesson]?
}

struct Lesson: Decodable {
    let id: Int
    let title: String
    let duration: Int
    let type: String
    let content: String?
    let quiz: Quiz?
    var isCompleted: Bool?
}

struct Quiz: Decodable {
    let id: Int
    let title: String
    let passPercentage: Int
    let questions: [QuestionCourses]

    enum CodingKeys: String, CodingKey {
        case id, title, questions
        case passPercentage = "pass_percentage"
    }
}

struct QuestionCourses: Decodable {
    let id: Int
    let title: String
    let type: String
    let points: Int
    let options: [String]?
    let left: [String]?
    let right: [String]?
}
