//
//  SearchViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

class SearchViewModel {
    
    // MARK: - Properties
    
    var courses: [Course] = [] // all courses
    var searchResults: [Course] = [] // results after search
    var filteredResults: [Course] = [] // results after filter
    var categories: [String] = []
    var levels: [String] = []
    var isLoading: Bool = false
    var errorMessage: String?
    private let apiService = APIService()
    
    // MARK: - Fetch Courses
    func fetchCourses(completion: @escaping (Bool) -> Void) {
        isLoading = true
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        print("subDomain: \(subDomain)")
        
        let url = "\(subDomain)/courses"
        print("Request URL: \(url)")
        
        apiService.fetchData(from: url) { [weak self] ( courseResponse: CourseResponse?, error) in
            self?.isLoading = false
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            if let courseResponse = courseResponse {
                self?.courses = courseResponse.data
                self?.searchResults = courseResponse.data
                self?.filteredResults = courseResponse.data
                completion(true)
            } else {
                self?.errorMessage = "No data found"
                completion(false)
            }
        }
    }
    
    // MARK: - Search Courses
    func searchCourses(with query: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        
        // fetch total courses if not get before
        if courses.isEmpty {
            fetchCourses { [weak self] success in
                if success {
                    self?.applySearch(query: query)
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            applySearch(query: query)
            completion(true)
        }
    }
    
    // MARK: - Apply Search
    private func applySearch(query: String) {
        if query.isEmpty {
            searchResults = courses
            filteredResults = courses
        } else {
            let resultsToSearch = filteredResults.isEmpty ? courses : filteredResults
            searchResults = resultsToSearch.filter { course in
                return course.title.localizedCaseInsensitiveContains(query) ||
                course.category.name.localizedCaseInsensitiveContains(query) ||
                course.instructor.name.localizedCaseInsensitiveContains(query)
            }
            filteredResults = searchResults
        }
    }
    
    
    // MARK: - Filter Courses
    func filterCourses(by category: String?, instructor: String?) {
        
        filteredResults = searchResults.filter { course in
            var matchesCategory = true
            var matchesInstructor = true
            
            if let category = category {
                matchesCategory = course.category.name == category
            }
            
            if let instructor = instructor {
                matchesInstructor = course.instructor.name == instructor
            }
            
            return matchesCategory && matchesInstructor
        }
    }
    
    // MARK: - Reset Filters
    func resetFilters() {
        filteredResults = searchResults
    }
    
    // MARK: - Apply Filters
    func applyFilters(selectedFilters: [String: [String]]) {
        filteredResults = searchResults.filter { course in
            for (filterKey, selectedValues) in selectedFilters {
                if let courseValue = courseValueForKey(filterKey, course),
                   !selectedValues.contains(courseValue) {
                    return false
                }
            }
            return true
        }
    }
    
    // MARK: - Course Value for Key
    private func courseValueForKey(_ key: String, _ course: Course) -> String? {
        switch key {
        case "Category":
            return course.category.name
        case "Instructor":
            return course.instructor.name
        default:
            return nil
        }
    }
}
