//
//  CourseInfoViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 12/03/2025.
//

import Foundation

class CourseInfoViewModel {
    private let course: Course
    
    init(course: Course) {
        self.course = course
    }
    
    func getCourseTitle() -> String {
        return course.title
    }
    
    func getCourseDescription() -> String {
        return course.description
    }
    func getFormattedDuration() -> String {
        guard let sections = course.sections else { return "0 h 0 min" }
        let totalSeconds = sections.reduce(0) { $0 + $1.duration }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours) h   \(minutes) min"
    }
    
    func getLessonsCount() -> String {
        guard let sections = course.sections else {
            return "0 Lessons"
        }
        
        let totalLessons = sections.reduce(0) { $0 + ($1.lessons?.count ?? 0) }
        
        return "\(totalLessons) Lessons"
        
    }
    
    func getInstructorName() -> String {
        return course.instructor?.name ?? ""
    }
    
    func getInstructorTitle() -> String {
        return course.instructor?.jobTitle ?? "Instructor"
    }
    
    func getInstructorImageURL() -> URL? {
        guard let imageString = course.instructor?.image else { return nil }
        return URL(string: imageString)
    }
    
    func getInstructorBio() -> String {
        return course.instructor?.bio ?? "No bio available"
    }
}
