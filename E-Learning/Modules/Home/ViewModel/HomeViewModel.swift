//
//  HomeViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 05/03/2025.
//

import Foundation
import UIKit

class HomeViewModel {
    static let shared = HomeViewModel()
    private var apiService = APIService()
    private var homeData: HomeResponse?
    var courseCategories: [CourseCategory] = []
    var courseInstructors: [Instructor] = []
    var latestCourses: [Course] = []
    var mostPopular: [Course] = []
    var featuredCourses: [Course] = []
    var isLoading = false
    var onDataFetched: (() -> Void)?
    
    private init() {}
    
    func fetchHomeData(token: String) {
        isLoading = true
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/home"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url, token: token) { [weak self] (homeResponse: HomeResponse?, error )in
            guard let self = self else { return }
            self.isLoading = false
            if let homeResponse = homeResponse {
                self.homeData = homeResponse
                self.courseCategories = homeResponse.categories
                self.courseInstructors = homeResponse.instructors
                self.latestCourses = homeResponse.latestCourses ?? []
                self.mostPopular = homeResponse.mostPopular ?? []
                self.featuredCourses = homeResponse.featured ?? []
                print("Course Categories count: \(self.courseCategories.count)")
                print("Course Instructors count: \(self.courseInstructors.count)")
                print("Latest courses count: \(self.latestCourses.count)")
                print("Most courses count: \(self.mostPopular.count)")
                print("Feature courses count: \(self.featuredCourses.count)")
                self.onDataFetched?()
            } else if let error = error {
                print("Error fetching home data: \(error)")
            }
        }
    }
    
    func getHomeData() -> HomeResponse? {
        return homeData
    }
    
    func getLatestCourseViewModels() -> [Course] {
        return latestCourses
    }

    func getMostCourseViewModels() -> [Course] {
        return mostPopular
    }

    func getFeaturedCourseViewModels() -> [Course] {
        return featuredCourses
    }
    
    func getCourseCategoriesViewModels() -> [CourseCategory] {
        return courseCategories
    }
}
