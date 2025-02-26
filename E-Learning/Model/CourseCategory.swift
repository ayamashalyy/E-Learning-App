//
//  CourseCategory.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation

struct CourseCategoryResponse: Decodable {
    let data: [CourseCategory]
    let links: Links
    let meta: Meta
}

struct CourseCategory: Decodable {
    let id: Int
    let name: String
    let slug: String
    let icon: String
    let image: String
    let color: String
}

struct Links: Decodable {
    let first: String
    let last: String
    let prev: String?
    let next: String?
}

struct Meta: Decodable {
    let currentPage: Int
    let from: Int
    let lastPage: Int
    let links: [Link]
    let path: String
    let perPage: Int
    let to: Int
    let total: Int
    
    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case from
        case lastPage = "last_page"
        case links
        case path
        case perPage = "per_page"
        case to
        case total
    }
}

struct Link: Decodable {
    let url: String?
    let label: String
    let active: Bool
}
