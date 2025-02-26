//
//  MyLearningResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

struct LearningResponse: Decodable {
    let inProgress: [Course]
    let assigned: [Course]
    let completed: [CompletedCourse]
    
    enum CodingKeys: String, CodingKey {
        case inProgress = "in_progress"
        case assigned
        case completed
    }
}

struct CompletedCourse: Decodable {
    let id: Int
    let title: String
    let image: String
    let slug: String
    let description: String
    let category: CourseCategory
    let instructor: Instructor
    let certificate: Certificate
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, slug, description, category, instructor, certificate
        case createdAt = "created_at"
    }
}

