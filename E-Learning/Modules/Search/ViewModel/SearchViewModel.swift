//
//  SearchViewModel.swift
//  E-Learning
//
//  Created by Aya Mashaly on 28/02/2025.
//

import Foundation

class SearchViewModel {
    
    struct Section {
        let title: String
        let items: [String]
    }
    
    // MARK: - Properties
    var onComplete: (() -> Void)?
    var currentState: SearchState = .recentSearches
    var courses: [Course] = [] // all courses
    var searchResults: [Course] = [] // results after search
    var filteredResults: [Course] = [] // results after filter
    var categories: [String] = []
    var levels: [String] = []
    var recentSearches: [String] = [] {
        didSet {
            print("1: \(recentSearches.count)")
            if recentSearches.isEmpty {
                print("1")
                currentState = .emptySearch
            } else {
                print("2")
                currentState = .recentSearches
            }
            
            (onComplete ?? {})()
        }
    } // Recent searches
    
    var sections: [Section] = []
    var selectedFilters: [String: [String]] = [:]
    var selectedFiltersCount: Int = 0
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
            return
        }
        
        searchResults = courses.filter { course in
            let isTitleMatch = course.title.localizedCaseInsensitiveContains(query)
            let isCategoryMatch = course.category.name.localizedCaseInsensitiveContains(query)
            let isInstructorMatch = course.instructor.name.localizedCaseInsensitiveContains(query)
            
            return isTitleMatch || isCategoryMatch || isInstructorMatch
        }
        
        filteredResults = searchResults
    }
    
    // MARK: - Reset Filters
    func resetFilters() {
        filteredResults = searchResults
    }
    
    // MARK: - Apply Filters
    func applyFilters(selectedFilters: [String: [String]]) {
        print("check filter - Selected Filters: \(selectedFilters)")
        filteredResults = searchResults.filter { course in
            for (filterKey, selectedValues) in selectedFilters {
                
                if selectedValues.isEmpty {
                    continue
                }
                
                if let courseValue = courseValueForKey(filterKey, course),
                   !selectedValues.contains(courseValue) {
                    return false
                }
            }
            return true
        }
        // print("check filter - Filtered Results: \(filteredResults)")
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
    
    // MARK: - Load Recent Searches
    func loadRecentSearches() {
        if let savedSearches = UserDefaults.standard.array(forKey: Constants.recentSearchesKey) as? [String] {
            recentSearches = savedSearches
        }
    }
    
    // MARK: - Save Recent Searches
    func saveRecentSearches() {
        UserDefaults.standard.set(recentSearches, forKey: Constants.recentSearchesKey)
    }
    
    // MARK: - Add Recent Search
    func addRecentSearch(_ searchTerm: String) {
        recentSearches.insert(searchTerm, at: 0)
        saveRecentSearches()
    }
    
    // MARK: - Delete Recent Search
    func deleteRecentSearch(at index: Int) {
        recentSearches.remove(at: index)
        saveRecentSearches()
    }
}
