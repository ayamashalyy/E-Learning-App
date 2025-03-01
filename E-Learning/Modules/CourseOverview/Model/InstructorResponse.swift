//
//  InstructorResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

struct InstructorResponse: Decodable {
    let data: [Instructor]
    let links: Links
    let meta: Meta
}
