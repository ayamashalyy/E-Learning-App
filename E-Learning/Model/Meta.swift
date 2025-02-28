//
//  Meta.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

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
