//
//  ProgressContinueViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/03/2025.
//

import Foundation

class ProgressContinueViewModel {
    let course: Course?
    
    init(course: Course?) {
        self.course = course
    }
    
    func getCourseTitle() -> String {
        return course?.title ?? "No Title"
    }
    
    func getCategoryName() -> String {
        return course?.category?.name ?? "Unknown"
    }
    
    func getProgressPercentageString() -> String {
        return "\(Int(course?.progress ?? 0))%"
    }
    
    func getProgressFloat() -> Float {
        return Float(course?.progress ?? 0)
    }
    
    func getImageUrl() -> URL? {
        guard let imageUrlString = course?.image else { return nil }
        return URL(string: imageUrlString)
    }
    
}
