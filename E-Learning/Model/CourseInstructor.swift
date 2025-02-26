//
//  CourseInstructor.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

struct Instructor: Decodable {
    let id: Int
    let name: String
    let image: String
    let jobTitle: String
    let bio: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, image, bio
        case jobTitle = "job_title"
    }
}
