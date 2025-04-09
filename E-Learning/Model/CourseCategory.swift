//
//  CourseCategory.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation

struct CourseCategory: Decodable {
    let id: Int
    let name: String
    let slug: String
    let icon: String
    let image: String
    let color: String
    let text_color: String
}
