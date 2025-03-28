//
//  CourseOverviewViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 11/03/2025.
//

import Foundation

class CourseOverviewViewModel {
    private var apiService = APIService()
    private var course: Course?
    var onDataFetched: (() -> Void)?
    private var selectedLesson: Lesson?
    
    func fetchCourseData(courseSlug: String, token: String) {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        
        let url = "\(subDomain)/courses/\(courseSlug)"
        apiService.fetchData(from: url, token: token) { [weak self] ( courseResponse:  CourseDetailsResponse?, error) in
            guard let self = self else { return }
            if let courseResponse = courseResponse {
                self.course = courseResponse.data
                self.onDataFetched?()
            } else if let error = error {
                print("Error fetching course data: \(error)")
            }
        }
    }
    
    func getCourse() -> Course? {
        return course
    }
    
    func isCourseEnrolled() -> Bool {
        return course?.isEnroll ?? false
    }
    
    func getCourseRequestStatus() -> String? {
        return course?.isRequest
    }
    
    func hasQuiz() -> Bool {
        return course?.hasQuiz ?? false
    }
    
    func getFormattedDuration() -> String {
        guard let sections = course?.sections else { return "0 h 0 min" }
        let totalSeconds = sections.reduce(0) { $0 + $1.duration }
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        return "\(hours) h   \(minutes) min"
    }
    
    func getLessonsCount() -> String {
        guard let sections = course?.sections else {
            return "0 Lessons"
        }
        
        let totalLessons = sections.reduce(0) { $0 + ($1.lessons?.count ?? 0) }
        
        return "\(totalLessons) Lessons"
        
    }
    
    func getInstructorName() -> String {
        return course?.instructor?.name ?? ""
    }
    
    func getInstructorTitle() -> String {
        return course?.instructor?.jobTitle ?? "Instructor"
    }
    
    func getInstructorImageURL() -> URL? {
        guard let imageString = course?.instructor?.image else { return nil }
        return URL(string: imageString)
    }
    
    func getInstructorBio() -> String {
        return course?.instructor?.bio ?? "No bio available"
    }
    
    func getSections() -> [SectionCourses] {
        return course?.sections ?? []
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
    
    func getComments() -> [Comment] {
        return course?.comments as? [Comment] ?? []
    }
    
    func setSelectedLesson(_ lesson: Lesson) {
        self.selectedLesson = lesson
        print("Set selected lesson: \(lesson.title)")
    }
    
    func getSelectedLesson() -> Lesson? {
        print("Returning selected lesson: \(selectedLesson?.title ?? "nil")")
        return selectedLesson
    }
    
    func getNextLesson() -> Lesson? {
        guard let currentLesson = selectedLesson else {
            print("No current lesson selected")
            return nil
        }
        
        let allSections = getSections()
        for (sectionIndex, section) in allSections.enumerated() {
            if let lessons = section.lessons {
                for (lessonIndex, lesson) in lessons.enumerated() {
                    if lesson.id == currentLesson.id {
                        if lessonIndex + 1 < lessons.count {
                            return lessons[lessonIndex + 1]
                        } else if sectionIndex + 1 < allSections.count {
                            return allSections[sectionIndex + 1].lessons?.first
                        }
                        return nil
                    }
                }
            }
        }
        print("No next lesson found")
        return nil
    }
}
