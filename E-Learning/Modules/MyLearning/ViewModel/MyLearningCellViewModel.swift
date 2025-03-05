//
//  MyLearningCellViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 26/02/2025.
//

import Foundation

class MyLearningCellViewModel {
    
    let courseTitle: String
    let courseImage: String
    let courseTitleCategory: String
    let instructorName: String
    let courseProgress: Int
    let state: LearningState
    
    init(course: Course, state: LearningState) {
        self.courseTitle = course.title
        self.courseImage = course.image
        self.instructorName = course.instructor.name
        self.courseTitleCategory = course.category.name
        self.courseProgress = course.progress
        self.state = state
    }
    
    init(completedCourse: Course) {
        self.courseTitle = completedCourse.title
        self.courseImage = completedCourse.image
        self.instructorName = completedCourse.instructor.name
        self.courseTitleCategory = completedCourse.category.name
        self.courseProgress = completedCourse.progress
        self.state = .completed
    }
}
