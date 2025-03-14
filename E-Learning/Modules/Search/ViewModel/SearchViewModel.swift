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
    var isFeatured: Bool?
    var errorMessage: String?
    private let apiService = APIService()
    
    // MARK: - Pagination Properties
    var currentPage: Int = 1
    var totalPages: Int = 1
    var isFetchingMore: Bool = false
    var currentSearchTerm: String?
    
    // MARK: - Fetch Courses with Filters
    func fetchCourses(with term: String? = nil, categoryId: Int? = nil, instructorId: Int? = nil, isFeatured: Bool? = nil, page: Int = 1, completion: @escaping (Bool) -> Void) {
        
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
        
        parameters["page"] = page
        
        // Convert parameters to query items
        var components = URLComponents(string: url)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        
        guard let finalURL = components?.url else {
            completion(false)
            return
        }
        print("Fetching courses with URL: \(finalURL.absoluteString)")
        apiService.fetchData(from: finalURL.absoluteString) { [weak self] (courseResponse: CourseResponse?, error) in
            
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            
            if let courseResponse = courseResponse {
                print("Courses fetched: \(courseResponse.data.count) items")
                if page == 1 {
                    self?.courses = courseResponse.data
                    self?.searchResults = courseResponse.data
                    self?.filteredResults = courseResponse.data
                } else {
                    self?.courses.append(contentsOf: courseResponse.data)
                    self?.searchResults.append(contentsOf: courseResponse.data)
                    self?.filteredResults.append(contentsOf: courseResponse.data)
                }
                self?.currentPage = page
                self?.totalPages = courseResponse.meta.lastPage
                completion(true)
            } else {
                self?.errorMessage = "No data found"
                completion(false)
            }
        }
    }
    
    // MARK: - Load More Courses
    func loadMoreCourses(completion: @escaping (Bool) -> Void) {
        guard !isFetchingMore, currentPage < totalPages else {
            completion(false)
            return
        }
        
        isFetchingMore = true
        currentPage += 1
        
        fetchCourses(with: currentSearchTerm,
                     categoryId: selectedCategoryId,
                     instructorId: selectedInstructorId,
                     isFeatured: isFeatured,
                     page: currentPage) { success in
            self.isFetchingMore = false
            completion(success)
        }
    }
    
    // MARK: - Search Courses
    func searchCourses(with query: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        currentPage = 1
        currentSearchTerm = query
        // Add the new search query to the beginning of the recent searches list
        addRecentSearch(query)
        
        // Fetch courses from the API with the search term
        fetchCourses(with: query, page: currentPage) { success in
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
        
        currentPage = 1
        currentSearchTerm = term
        let categoryId = selectedCategoryId
        let instructorId = selectedInstructorId
        let isFeatured = isFeatured
        // Fetch courses with the selected filters
        if let term {
            fetchCourses(with: term, categoryId: categoryId, instructorId: instructorId, isFeatured: isFeatured, page: currentPage) { success in
                if success {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        } else {
            fetchCourses(categoryId: categoryId, instructorId: instructorId, isFeatured: isFeatured, page: currentPage) { success in
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
