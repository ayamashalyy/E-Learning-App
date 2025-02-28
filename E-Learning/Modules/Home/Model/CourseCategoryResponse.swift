//
//  CourseCategoryResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

struct CourseCategoryResponse: Decodable {
    let data: [CourseCategory]
    let links: Links
    let meta: Meta
}
