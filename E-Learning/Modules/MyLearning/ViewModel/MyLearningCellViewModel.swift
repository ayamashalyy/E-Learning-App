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
    let certificate: String?
    
    init(course: Course, state: LearningState) {
        self.courseTitle = course.title
        self.courseImage = course.image
        self.instructorName = course.instructor?.name ?? "Unknown Instructor"
        self.courseTitleCategory = course.category?.name ?? ""
        self.courseProgress = course.progress ?? 0
        self.state = state
        self.certificate = course.certificate?.image
    }
}
