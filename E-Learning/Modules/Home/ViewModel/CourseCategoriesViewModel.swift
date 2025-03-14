//
//  CourseCategoriesViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 14/03/2025.
//

import Foundation
import UIKit

class CourseCategoriesViewModel {
    
    private(set) var categories: [CourseCategory] = [] {
        didSet {
            onCategoriesUpdated?()
        }
    }
    
    var onCategoriesUpdated: (() -> Void)?
    
    func updateCategories(_ newCategories: [CourseCategory]) {
        self.categories = newCategories
    }
    
    func getCategory(at index: Int) -> CourseCategory? {
        guard index >= 0, index < categories.count else { return nil }
        return categories[index]
    }
    
    func getCategoriesCount() -> Int {
        return categories.count
    }
    
    func sizeForCategory(at index: Int) -> CGSize {
        guard let category = getCategory(at: index) else {
            return CGSize(width: 100, height: 60)
        }
        let font = UIFont(name: "Roboto-Bold", size: 16) ?? .boldSystemFont(ofSize: 14)
        let textWidth = category.name.width(usingFont: font)
        let padding: CGFloat = 50
        return CGSize(width: textWidth + padding, height: 60)
    }
}
