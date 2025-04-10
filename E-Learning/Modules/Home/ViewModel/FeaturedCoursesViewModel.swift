//
//  FeaturedCourseModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 06/03/2025.
//

import Foundation

class FeaturedCoursesViewModel {
    
    private(set) var courses: [Course] = [] {
        didSet {
            onCoursesUpdated?()
        }
    }
    
    var onCoursesUpdated: (() -> Void)?
    
    func updateCourses(_ newCourses: [Course]) {
        self.courses = newCourses
    }
    
    func getCourse(at index: Int) -> Course? {
        guard index >= 0, index < courses.count else { return nil }
        let course = courses[index]
        return course
    }
    
    func getCoursesCount() -> Int {
        return courses.count
    }
}
