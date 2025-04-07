//
//  Course.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

struct Course: Decodable {
    let id: Int
    var isEnroll: Bool?
    var isRequest: String?
    let hasQuiz: Bool?
    let title: String
    let image: String
    let slug: String
    let description: String
    let category: CourseCategory?
    let instructor: Instructor?
    let sections: [SectionCourses]?
    let comments: [Comment]?
    let certificate: Certificate?
    let progress: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, slug, description, category, instructor, sections, comments, certificate, progress
        case createdAt = "created_at"
        case isEnroll = "is_enroll"
        case isRequest = "is_request"
        case hasQuiz = "has_quiz"
    }
}
