//
//  CourseResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

struct CourseResponse: Decodable {
    let data: [Course]
    let links: Links
    let meta: Meta
}
