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
        let items: [(id: Int, name: String)]
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
    var selectedCategoryId: Int?
    var selectedInstructorId: Int?
    var errorMessage: String?
    private let apiService = APIService()
    
    // MARK: - Fetch Courses with Filters
    func fetchCourses(with term: String? = nil, categoryId: Int? = nil, instructorId: Int? = nil, isFeatured: Bool? = nil, completion: @escaping (Bool) -> Void) {
        
        let subDomain = TenantViewModel.shared.urlTenant ?? ""
        let url = "\(subDomain)/courses"
        
        // Add parameters to the URL
        var parameters: [String: Any] = [:]
        if let term = term {
            parameters["term"] = term
        }
        if let categoryId = categoryId {
            parameters["category_id"] = categoryId
        }
        if let instructorId = instructorId {
            parameters["instructor_id"] = instructorId
        }
        if let isFeatured = isFeatured {
            parameters["is_feather"] = isFeatured
        }
        
        // Convert parameters to query items
        var components = URLComponents(string: url)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let finalURL = components?.url else {
            completion(false)
            return
        }
        
        print("Final URL: \(finalURL.absoluteString)")
        apiService.fetchData(from: finalURL.absoluteString) { [weak self] (courseResponse: CourseResponse?, error) in
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            if let courseResponse = courseResponse {
                print("Courses: \(courseResponse.data)")
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
        
        // Add the new search query to the beginning of the recent searches list
        addRecentSearch(query)
        
        // Fetch courses from the API with the search term
        fetchCourses(with: query) { success in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    // MARK: - Reset Filters
    func resetFilters(completion: @escaping (Bool) -> Void) {
        
        // Reset selected filters
        selectedCategoryId = nil
        selectedInstructorId = nil
        selectedFilters.removeAll()
        selectedFiltersCount = 0
        
        // Fetch all courses without any filters
        fetchCourses { [weak self] success in
            if success {
                self?.currentState = .totalResultsBeforeFilter
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: - Apply Filters
    func applyFilters(selectedFilters: [String: [String]],term: String?, completion: @escaping (Bool) -> Void) {
        
        let categoryId = selectedCategoryId
        let instructorId = selectedInstructorId
        
        // Fetch courses with the selected filters
        if let term {
            fetchCourses(with: term, categoryId: categoryId, instructorId: instructorId) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            fetchCourses(categoryId: categoryId, instructorId: instructorId) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
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
