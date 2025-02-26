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
    let progress: Float
    let state: LearningState
    
    init(course: Course, state: LearningState) {
        self.courseTitle = course.title
        self.courseImage = course.image
        self.instructorName = course.instructor.name
        self.courseTitleCategory = course.category.name
        self.progress = 6.0
        self.state = state
    }
    
    init(completedCourse: CompletedCourse) {
        self.courseTitle = completedCourse.title
        self.courseImage = completedCourse.image
        self.instructorName = completedCourse.instructor.name
        self.courseTitleCategory = completedCourse.category.name
        self.progress = 1.0
        self.state = .completed
    }
}
