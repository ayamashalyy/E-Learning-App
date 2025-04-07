//
//  Requests.swift
//  E-Learning
//
//  Created by Aya Mashaly on 07/04/2025.
//

import Foundation

struct RequestsResponse: Decodable {
    let data: [RequestDetails]
}

struct RequestDetails: Decodable {
    let id: Int
    let learner: LearnerDetails
    let course: CourseDetails
    let status: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, learner, course, status
        case createdAt = "created_at"
    }
}

struct UpdateRequestStatusBody: Encodable {
    let status: String
}

struct UpdateRequestStatusResponse: Decodable {
    let message: String
    let exception: String?
}
