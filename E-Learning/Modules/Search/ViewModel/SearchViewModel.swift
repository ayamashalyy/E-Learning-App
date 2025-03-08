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
    var currentState: SearchState = .emptySearch
    var courses: [Course] = [] // all courses
    var searchResults: [Course] = [] // results after search
    var filteredResults: [Course] = [] // results after filter
    var categories: [String] = []
    var isLoading = false
    var levels: [String] = []
    var recentSearches: [String] = [] {
        didSet {
            saveRecentSearches()
            print("recentSearches count : \(recentSearches.count)")
            if recentSearches.isEmpty {
                print("1")
                currentState = .emptySearch
            } else if isLoading {
                currentState = .loading
            } else {
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
    var isFeatured: Bool = false
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
        isLoading = true
        // Add the new search query to the beginning of the recent searches list
        addRecentSearch(query)
        
        // Fetch courses from the API with the search term
        fetchCourses(with: query) { success in
            self.isLoading = false
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // MARK: - Apply Filters
    func applyFilters(selectedFilters: [String: [String]], term: String? = nil, completion: @escaping (Bool) -> Void) {
        
        let categoryId = selectedCategoryId
        let instructorId = selectedInstructorId
        let isFeatured = isFeatured
        // Fetch courses with the selected filters
        if let term {
            fetchCourses(with: term, categoryId: categoryId, instructorId: instructorId, isFeatured: isFeatured) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            fetchCourses(categoryId: categoryId, instructorId: instructorId, isFeatured: isFeatured) { success in
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
            print("RecentSearches Count load - \(recentSearches.count) ")
        }
    }
    
    // MARK: - Save Recent Searches
    func saveRecentSearches() {
        DispatchQueue.main.async {
            UserDefaults.standard.set(self.recentSearches, forKey: Constants.recentSearchesKey)
            UserDefaults.standard.synchronize()
            print("Recent Searches Saved: \(self.recentSearches)")
        }
    }
    
    // MARK: - Add Recent Search
    func addRecentSearch(_ searchTerm: String) {
        recentSearches.insert(searchTerm, at: 0)
        saveRecentSearches()
    }
    
    // MARK: - Delete Recent Search
    func deleteRecentSearch(at index: Int) {
        print("Before Deletion: \(recentSearches)")
        recentSearches.remove(at: index)
        print("After Deletion: \(recentSearches)")
    }
    
    // MARK: - fill sections in filter Collection
    func updateSections(categories: [CourseCategory], instructors: [Instructor]) {
        let categoryItems = categories.map { ($0.id, $0.name) }
        let instructorItems = instructors.map { ($0.id, $0.name) }
        let featuredItems = [(id: 1, name: "Yes")]
        
        sections = [
            SearchViewModel.Section(title: "Category".localized, items: categoryItems),
            SearchViewModel.Section(title: "Instructor".localized, items: instructorItems),
            SearchViewModel.Section(title: "Is Featurer".localized, items: featuredItems)
        ]
        
    }
}
