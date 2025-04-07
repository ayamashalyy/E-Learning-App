//
//  LearnerDetails.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/04/2025.
//

import Foundation

struct LearnerDetailsResponse: Decodable {
    let requestsCount: Int?
    let learner: LearnerDetails
    let courses: [CourseDetails]
    
    enum CodingKeys: String, CodingKey {
        case learner, courses
        case requestsCount = "requests_count"
    }
}

struct LearnerDetails: Decodable {
    let id: Int
    let name: String
    let email: String
    let avatar: String?
}

struct CourseDetails: Decodable {
    let id: Int
    let title: String
    let image: String
    let slug: String
    let description: String
    let category: CourseCategory?
    let instructor: Instructor?
    let certificate: Certificate?
    let progress: Int?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, slug, description, category, instructor, certificate, progress
        case createdAt = "created_at"
    }
}

struct AssignCourseResponse: Decodable {
    let message: String
}
