//
//  CourseContentViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 13/03/2025.
//

import Foundation

class CourseContentViewModel {
    private let course: Course
    
    init(course: Course) {
        self.course = course
    }
    
    func getSections() -> [SectionCourses] {
        return course.sections ?? []
    }
    
    func getSectionsCount() -> Int {
        return getSections().count
    }
    
    func getLessonsCount(forSection sectionIndex: Int) -> Int {
        let sections = getSections()
        guard sectionIndex < sections.count else { return 0 }
        return sections[sectionIndex].lessons?.count ?? 0
    }
    
    func getLesson(at indexPath: IndexPath) -> Lesson? {
        let sections = getSections()
        guard indexPath.section < sections.count else { return nil }
        let lessons = sections[indexPath.section].lessons ?? []
        guard indexPath.row < lessons.count else { return nil }
        return lessons[indexPath.row]
    }
    
    func getSectionTitle(forSection sectionIndex: Int) -> String {
        let sections = getSections()
        guard sectionIndex < sections.count else { return "UnKnown" }
        return sections[sectionIndex].title
    }
    
    func formatDuration(_ duration: Int?) -> String {
        let durationInSeconds = duration ?? 0
        let minutes = durationInSeconds / 60
        return "\(minutes) min"
    }
    
}
