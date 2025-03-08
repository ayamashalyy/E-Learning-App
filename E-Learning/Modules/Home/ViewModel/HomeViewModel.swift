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
                self.latestCourses = homeResponse.latestCourses
                self.mostPopular = homeResponse.mostPopular
                self.featuredCourses = homeResponse.featured
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
    
    func getLatestCourseViewModels() -> [FeaturedCourseModel] {
        return latestCourses.map { course in
            FeaturedCourseModel(
                slug: course.slug, title: course.title, instructorName: course.instructor.name, image: course.image
            )
        }
    }
    
    func getMostCourseViewModels() -> [FeaturedCourseModel] {
        return mostPopular.map { course in
            FeaturedCourseModel(
                slug: course.slug, title: course.title, instructorName: course.instructor.name, image: course.image
            )
        }
    }
    
    func getFeaturedCourseViewModels() -> [FeaturedCourseModel] {
        return featuredCourses.map { course in
            FeaturedCourseModel(
                slug: course.slug, title: course.title, instructorName: course.instructor.name, image: course.image
            )
        }
    }
    
    func getCourseCategoriesViewModels() -> [CourseCategoriesModel] {
        return courseCategories.map { course in
            CourseCategoriesModel(id: course.id, slug: course.slug , name: course.name, color: UIColor(hex: course.color), image: course.image)
        }
    }
}
