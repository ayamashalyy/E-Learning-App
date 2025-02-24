//
//  CourseCategoryCellViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation
import UIKit

class CourseCategoryCellViewModel {
    let name: String
    let color: UIColor
    
    init(courseCategory: CourseCategory) {
        self.name = courseCategory.name
        self.color = UIColor(hex: courseCategory.color)
    }
}
