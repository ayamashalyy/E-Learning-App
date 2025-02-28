//
//  Course.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

struct Course: Decodable {
    let id: Int
    let title: String
    let image: String
    let slug: String
    let description: String
    let category: CourseCategory
    let instructor: Instructor
    let progress: Int
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, image, slug, description, category, instructor, progress
        case createdAt = "created_at"
    }
}
