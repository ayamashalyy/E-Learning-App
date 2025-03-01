//
//  CourseCategoriesViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 21/02/2025.
//

import Foundation

class CourseCategoriesViewModel {
    
    private var apiService = APIService()
    var courseCategories: [CourseCategory] = []
    var onDataFetched: (() -> Void)?
    
    func fetchCourseCategories() {
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/course-categories"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url) { [weak self] (response: CourseCategoryResponse?, Error) in
            guard let self = self, let response = response else { return }
            self.courseCategories = response.data
            self.onDataFetched?()
        }
    }
    
    func numberOfCategories() -> Int {
        return courseCategories.count
    }
    
    func cellViewModel(at index: Int) -> CourseCategoryCellViewModel {
        let courseCategory = courseCategories[index]
        return CourseCategoryCellViewModel(courseCategory: courseCategory)
    }
}
