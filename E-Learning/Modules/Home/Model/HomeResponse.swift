//
//  HomeResponse.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/03/2025.
//

import Foundation

struct HomeResponse: Decodable {
    let lastCourseWatched: String?
    let categories: [CourseCategory]
    let instructors: [Instructor]
    let mostPopular: [Course]
    let featured: [Course]
    let latestCourses: [Course]
    
    enum CodingKeys: String, CodingKey {
        case lastCourseWatched = "last_course_watched"
        case categories
        case instructors
        case mostPopular = "most_popular"
        case featured
        case latestCourses = "latest_courses"
    }
}

